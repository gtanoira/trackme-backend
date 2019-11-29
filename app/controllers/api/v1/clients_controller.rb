module Api
  module V1

    class ClientsController < Api::V1::ApplicationController

      # Get all the Clients
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @clients = Client.includes(:country, :company).order(name: :asc).all.map do |r|
            {
              id: r.id,
              name: r.name,
              alias: r.alias,
              countryId: r.country_id,
              countryName: r.country.name,
              companyId: r.company_id,
              companyName: r.company.name
            }
          end
          
          respond_to do |format|
            format.json { render json: @clients }
          end
        end
      end

    end
  end
end