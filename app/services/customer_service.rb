# app/services/customer_service.rb
class CustomerService
  def initialize(params = {})
    @params = params
    @redis = Redis.new(host: 'localhost', port: 6380)
  end

  def all_customers
    Customer.all.to_a
  end

  def find_customer(id)
    cache_key = "customer:#{id}"
    cached_customer = @redis.get(cache_key)

    if cached_customer
      Rails.logger.info "Customer #{id} found in Redis cache"
      Customer.new(JSON.parse(cached_customer)) # Assuming Redis stores JSON data
    else
      customer = Customer.find(id)
      @redis.set(cache_key, customer.to_json)
      Rails.logger.info "Customer #{id} not found in Redis cache. Queried from DB and cached."
      customer
    end
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def create_customer
    customer = Customer.new(customer_params)
    if customer.save
      @redis.set("customer:#{customer.id}", customer.to_json)
      { success: true, customer: customer }
    else
      { success: false, errors: customer.errors }
    end
  end

  def update_customer(id)
    customer = Customer.find(id)
    if customer.update(customer_params)
      @redis.set("customer:#{customer.id}", customer.to_json)
      { success: true, customer: customer }
    else
      { success: false, errors: customer.errors }
    end
  rescue Mongoid::Errors::DocumentNotFound
    { success: false, errors: { base: ["Customer not found"] } }
  end

  def destroy_customer(id)
    customer = Customer.find(id)
    customer.destroy
    @redis.del("customer:#{id}")
    { success: true }
  rescue Mongoid::Errors::DocumentNotFound
    { success: false, errors: { base: ["Customer not found"] } }
  end

  private

  def customer_params
    @params.require(:customer).permit(:name, :dob, :address, :phone)
  end
end
