module Api
  module V1

    class WarehousesController < ApplicationController
      #before_action :authenticate_user!

      # Helpers
      helper ApisHelper
      helper AuthorizationsHelper

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)
          # Get the companies that the user can access
          company_ids = helpers.get_user_companies(user_id)

          if company_ids == [-1] then
            @warehouses = Warehouse
              .joins(company: [{ account: :users }])
              .where("users.id = #{user_id}")
          else
            @warehouses = Warehouse
              .joins(:company)
              .where(company_id: company_ids)
          end

          @rtn_json = @warehouses.map do |o|
            {
              id: o.id,
              name: o.name,
              companyId: o.company_id,
              companyName: o.company.name
            }
          end
          
          respond_to do |format|
            format.html
            format.json { render json: @rtn_json }
          end
        end
      end

    end

  end
end
