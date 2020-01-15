module Api
  module V1

    class ItemModelsController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # Create a new item model
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Save the client item model
          begin
            item_model_data = ItemModel.new
            item_model_data.client_id = params['clientId']
            item_model_data.model = params['model']
            item_model_data.manufacter = params['manufacter']
            item_model_data.unit_length = params['unitLength']
            item_model_data.width = params['width']
            item_model_data.height = params['height']
            item_model_data.length = params['length']
            item_model_data.unit_weight = params['unitWeight']
            item_model_data.weight = params['weight']
            item_model_data.unit_volumetric = params['unitVolumetric']
            item_model_data.volume_weight = params['volumeWeight']
            item_model_data.save!

            respond_to do |format|
              format.json { render json: {message: 'Model saved.'} }
            end

          rescue => e
            puts "Error #{e.class}: #{e.message}"
            puts "ERROR BACKTRACE:"
            puts e.backtrace
            respond_to do |format|
              format.json { render json: {message: 'Error saving the item model.',
                                          extraMsg: e.message} }
            end
          end

        end
      end

      # ******************************************************************************
      # Get all the item models of a client
      # 
      # Response
      #   Content-type: application/json;
      #   Body: JSON file
      #
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the order ID from PARAMS
          pclient_id = params[:client_id].to_i

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)
          # Get allow companies
          company_ids = helpers.get_user_companies(user_id)
          # Get allow clients
          client_ids = helpers.get_user_clients(user_id)

          @datos = ItemModel
            .joins("INNER JOIN entities ON entities.id = item_models.client_id")
            .where("item_models.client_id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
            .where("entities.company_id IN (#{company_ids.join(',')}) OR #{company_ids == [-1]}")
            .where(client_id: pclient_id)
            .order(model: :asc)
            .map do |o|
              {
                id: o.id,
                clientId: o.client_id,
                clientName: o.entity.name,
                model: o.model,
                manufacter: o.manufacter,
                unitLength: o.unit_length,
                width: o.width,
                height: o.height,
                length: o.length,
                unitWeight: o.unit_weight,
                weight: o.weight,
                unitVolumetric: o.unit_volumetric,
                volumeWeight: o.volume_weight
              }
            end
          
          respond_to do |format|
            format.json { render json: @datos }
          end
        end
      end

    end
  end
end
