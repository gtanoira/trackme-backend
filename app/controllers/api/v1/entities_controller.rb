module Api
  module V1

    class EntitiesController < Api::V1::ApplicationController

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          if params[:type] != nil then
            @entities = Entity.includes(:country).where(entity_type: params[:type].upcase).order(name: :asc).all
          else
            @entities = Entity.includes(:country).order(name: :asc).all
          end
          
          respond_to do |format|
            format.html
            format.json { render json: @entities }
          end
        end
      end


      # ******************************************************************************
      # Get a Customer Order by id
      # 
      # URL: /api/entities/[:id].json
      # Method: GET
      # URL params: 
      #   id: entity ID.
      # Response: 
      #   Content-type: application/json
      #   body: (JSON) => entity data
      # 
      def show
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          rec_id = params[:id].to_i
          begin
            o = Entity.find(rec_id)
            @rec = {  
              id: o.id,
              name: o.name,
              address1: o.address1,
              address2: o.address2,
              city: o.city,
              zipcode: o.zipcode,
              state: o.state,
              alias: o.alias,
              entityType: o.entity_type,
              countryId: o.country_id,
              companyId: o.company_id
            }
          rescue ActiveRecord::RecordNotFound
            @rec = {}
          end

          respond_to do |format|
            format.json { render json: @rec }
          end
        end
      end

    end
  end
end