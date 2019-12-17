module Api
  module V1

    class ClientsController < Api::V1::ApplicationController

      # Get all the Clients
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)
          # Get allow companies
          company_ids = helpers.get_user_companies(user_id)
          # Get allow clients
          client_ids = helpers.get_user_clients(user_id)

          if company_ids == [-1] then
            @clients = Client
              .joins(company: [{ account: :users }])
              .where("users.id = #{user_id}")
              .where("entities.id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
              .includes(:country)
              .order(name: :asc)
          else
            @clients = Client
              .where(company_id: company_ids)
              .where("entities.id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
              .includes(:country)
              .order(name: :asc)
          end
         
          @rtn_json = @clients.map do |r|
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
            format.json { render json: @rtn_json }
          end
        end
      end

    end
  end
end