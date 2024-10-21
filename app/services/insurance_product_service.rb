# app/services/insurance_product_service.rb

class InsuranceProductService
  def initialize(params)
    @params = params
  end

  def all_insurance_products
    InsuranceProduct.all
  end

  def find_insurance_product(id)
    InsuranceProduct.find(id)
  end

  def create_insurance_product
    insurance_product = InsuranceProduct.new(@params.require(:insurance_product).permit(:name))
    if insurance_product.save
      { success: true, insurance_product: insurance_product }
    else
      { success: false, errors: insurance_product.errors }
    end
  end

  def update_insurance_product(id)
    insurance_product = InsuranceProduct.find(id)
    if insurance_product.update(@params.require(:insurance_product).permit(:name))
      { success: true, insurance_product: insurance_product }
    else
      { success: false, errors: insurance_product.errors }
    end
  end

  def destroy_insurance_product(id)
    insurance_product = InsuranceProduct.find(id)
    insurance_product.destroy
  end
end
