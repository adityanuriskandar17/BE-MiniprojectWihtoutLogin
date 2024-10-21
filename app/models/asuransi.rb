class Asuransi
  include Mongoid::Document
  field :status, type: String
  field :active_date, type: Date
  field :expire_date, type: Date

  # belongs_to :user
  belongs_to :customer
  belongs_to :insurance_product

  validates :status, inclusion: { in: %w(active inactive) }
  validate :only_one_active_per_customer

  private

  def only_one_active_per_customer
    if status == 'active' && Asuransi.where(customer_id: customer_id, status: 'active').exists?
      errors.add(:status, 'A customer can only have one active Asuransi.')
    end
  end
end