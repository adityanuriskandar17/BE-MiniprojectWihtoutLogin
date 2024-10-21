# models/customer_event.rb
class CustomerEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  after_save :update_customer_cache
  after_destroy :remove_customer_cache

  private

  def update_customer_cache
    $redis.set("customer:#{self.id}", self.to_json)
  end

  def remove_customer_cache
    $redis.del("customer:#{self.id}")
  end
end
