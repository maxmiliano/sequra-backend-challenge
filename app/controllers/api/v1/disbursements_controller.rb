module Api
  module V1
    class DisbursementsController < ApplicationController
      def index
        @disbursement = Disbursement.where(_index_params)
        render json: @disbursement
      end

      def _index_params
        params.permit(:merchant_id, :year, :week)
      end
    end
  end
end