module Api
  module V1

    class CompaniesController < Api::V1::ApplicationController
      #before_action :authenticate_user!

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @companies = Company.all
          
          respond_to do |format|
            format.html
            format.json { render json: @companies }
          end
        end
      end
    end

  end
end