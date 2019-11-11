module Api
  module V1

    class CountriesController < Api::V1::ApplicationController
      # before_action :authenticate_user!

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @countries = Country.order(name: :asc).all
          
          respond_to do |format|
            format.html
            format.json { render json: @countries }
          end
        end
      end

    end

  end
end
