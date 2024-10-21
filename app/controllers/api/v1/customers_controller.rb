# app/controllers/api/v1/customers_controller.rb
module Api
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer_service, only: [:index, :show, :create, :update, :destroy]

      def index
        customers = @customer_service.all_customers
        render json: CustomerSerializer.new(customers).serializable_hash.to_json
      end

      def show
        customer = @customer_service.find_customer(params[:id])
        if customer
          render json: CustomerSerializer.new(customer).serializable_hash.to_json
        else
          render json: { errors: { base: ["Customer not found"] } }, status: :not_found
        end
      end

      def create
        result = @customer_service.create_customer
        if result[:success]
          render json: CustomerSerializer.new(result[:customer]).serializable_hash.to_json, status: :created
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def update
        result = @customer_service.update_customer(params[:id])
        if result[:success]
          render json: CustomerSerializer.new(result[:customer]).serializable_hash.to_json
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def destroy
        result = @customer_service.destroy_customer(params[:id])
        if result[:success]
          head :no_content
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      private

      def set_customer_service
        @customer_service = CustomerService.new(params)
      end
    end    
  end
end
