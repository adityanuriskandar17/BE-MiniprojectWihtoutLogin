# app/controllers/api/v1/insurance_products_controller.rb

module Api
  module V1
    class InsuranceProductsController < ApplicationController
      before_action :set_insurance_product_service, only: [:index, :show, :create, :update, :destroy]

      def index
        insurance_products = @insurance_product_service.all_insurance_products
        render json: InsuranceProductSerializer.new(insurance_products).serializable_hash.to_json
      end

      def show
        insurance_product = @insurance_product_service.find_insurance_product(params[:id])
        render json: InsuranceProductSerializer.new(insurance_product).serializable_hash.to_json
      end

      def create
        result = @insurance_product_service.create_insurance_product
        if result[:success]
          render json: InsuranceProductSerializer.new(result[:insurance_product]).serializable_hash.to_json, status: :created
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def update
        result = @insurance_product_service.update_insurance_product(params[:id])
        if result[:success]
          render json: InsuranceProductSerializer.new(result[:insurance_product]).serializable_hash.to_json
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def destroy
        @insurance_product_service.destroy_insurance_product(params[:id])
        head :no_content
      end

      private

      def set_insurance_product_service
        @insurance_product_service = InsuranceProductService.new(params)
      end
    end
  end
end
