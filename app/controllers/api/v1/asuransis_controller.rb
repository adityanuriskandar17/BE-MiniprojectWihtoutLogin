# app/controllers/api/v1/asuransis_controller.rb

module Api
  module V1
    class AsuransisController < ApplicationController
      before_action :set_asuransi_service, only: [:index, :show, :create, :update, :destroy]

      def index
        asuransis = @asuransi_service.all_asuransis
        render json: AsuransiSerializer.new(asuransis).serializable_hash.to_json
      end

      def show
        asuransi = @asuransi_service.find_asuransi(params[:id])
        if asuransi
          render json: AsuransiSerializer.new(asuransi).serializable_hash.to_json
        else
          render json: { error: 'Asuransi not found' }, status: :not_found
        end
      end

      def create
        result = @asuransi_service.create_asuransi
        if result[:success]
          render json: AsuransiSerializer.new(result[:asuransi]).serializable_hash.to_json, status: :created
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def update
        result = @asuransi_service.update_asuransi(params[:id])
        if result[:success]
          render json: AsuransiSerializer.new(result[:asuransi]).serializable_hash.to_json
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      def destroy
        @asuransi_service.destroy_asuransi(params[:id])
        head :no_content
      end

      private

      def set_asuransi_service
        @asuransi_service = AsuransiService.new(params)
      end
    end
  end
end
