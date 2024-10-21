class Customer
  include Mongoid::Document
  field :name, type: String
  field :dob, type: Date
  field :address, type: String
  field :phone, type: String

  # belongs_to :user
  has_many :asuransis

  after_save :update_customer_cache
  after_destroy :remove_customer_cache

  private

  def update_customer_cache
    Rails.logger.info "Updating Redis cache for customer: #{self.id}"
    $redis.set("customer:#{self.id}", self.to_json)
  end

  def remove_customer_cache
    Rails.logger.info "Removing Redis cache for customer: #{self.id}"
    $redis.del("customer:#{self.id}")
  end
end