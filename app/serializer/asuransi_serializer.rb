# app/serializers/asuransi_serializer.rb

class AsuransiSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :active_date, :expire_date, :customer_id, :insurance_product_id

  belongs_to :customer
  belongs_to :insurance_product

  # opsional
  # attribute :formatted_active_date do |asuransi|
  #   asuransi.active_date.strftime("%Y-%m-%d") if asuransi.active_date
  # end

  # attribute :formatted_expire_date do |asuransi|
  #   asuransi.expire_date.strftime("%Y-%m-%d") if asuransi.expire_date
  # end
end
