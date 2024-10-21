# app/services/asuransi_service.rb

class AsuransiService
  def initialize(params)
    @params = params
  end

  def all_asuransis
    Asuransi.all
  end

  def find_asuransi(id)
    Asuransi.find(id)
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def create_asuransi
    asuransi = Asuransi.new(asuransi_params)
    if asuransi.save
      { success: true, asuransi: asuransi }
    else
      { success: false, errors: asuransi.errors }
    end
  end

  def update_asuransi(id)
    asuransi = find_asuransi(id)
    if asuransi && asuransi.update(asuransi_params)
      { success: true, asuransi: asuransi }
    else
      { success: false, errors: asuransi&.errors || { base: "Not found" } }
    end
  end

  def destroy_asuransi(id)
    asuransi = find_asuransi(id)
    asuransi.destroy if asuransi
  end

  private

  def asuransi_params
    @params.require(:asuransi).permit(:status, :active_date, :expire_date, :customer_id, :insurance_product_id)
  end
end
