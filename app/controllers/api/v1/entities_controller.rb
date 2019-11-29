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

    end
  end
end