module Api
  module V1

    class ItemsController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # Create a new order Item
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the order ID
          order_id = params[:order_id].to_i

          # Save the order item data
          begin
            order_item_data = Item.new
            order_item_data.item_id = params['itemId']
            order_item_data.warehouse_id = params['warehouseId']
            order_item_data.client_id = params['clientId']
            order_item_data.order_id = params['orderId']
            order_item_data.item_type = params['itemType']
            order_item_data.status = params['status']
            order_item_data.quantity = params['quantity']
            if params['deletedBy'].present? then
              order_item_data.deleted_by = params['deletedBy']
            end
            if params['deletedCause'].present? then
              order_item_data.deleted_cause = params['deletedCause']
            end
            if params['deletedDatetime'].present? then
              order_item_data.deleted_datetime = params['deletedDatetime']
            end
            if params['description'].present? then
              order_item_data.description = params['description']
            end
            if params['imageFilename'].present? then
              order_item_data.image_filename = params['imageFilename']
            end
            if params['contentFilename'].present? then
              order_item_data.content_filename = params['contentFilename']
            end
            if params['manufacter'].present? then
              order_item_data.manufacter = params['manufacter']
            end
            if params['model'].present? then
              order_item_data.model = params['model']
            end
            order_item_data.part_number = params['partNumber']
            order_item_data.serial_number = params['serialNumber']
            order_item_data.ua_number = params['uaNumber']
            order_item_data.condition = params['condition']
            if params['unitLength'].present? then
              order_item_data.unit_length = params['unitLength']
              order_item_data.width = params['width']
              order_item_data.height = params['height']
              order_item_data.length = params['length']
            end
            if params['unitWeight'].present? then
              order_item_data.unit_weight = params['unitWeight']
              order_item_data.weight = params['weight']
            end
            if params['unitVolumetric'].present? then
              order_item_data.unit_volumetric = params['unitVolumetric']
              order_item_data.volume_weight = params['volumeWeight']
            end
            order_item_data.save!

            respond_to do |format|
              format.json { render json: {message: 'Item saved.'} }
            end

          rescue => e
            puts "Error #{e.class}: #{e.message}"
            puts "ERROR BACKTRACE:"
            puts e.backtrace
            respond_to do |format|
              format.json { render json: {message: 'Error saving the item into the order',
                                          extraMsg: e.message} }
            end
          end

        end
      end

      # ******************************************************************************
      # Get all the items of an order
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

          # Get the order ID
          p_order_id = params[:order_id].to_i

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)
          # Get allow companies
          company_ids = helpers.get_user_companies(user_id)
          # Get allow clients
          client_ids = helpers.get_user_clients(user_id)

          @items = Item
            .joins("INNER JOIN entities ON entities.id = items.client_id")
            .where("items.client_id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
            .where("entities.company_id IN (#{company_ids.join(',')}) OR #{company_ids == [-1]}")
            .where(order_id: p_order_id)
            .includes(:warehouse)
            .map do |o|
            {
              id: o.id,
              itemId: o.item_id,
              warehouseId: o.warehouse_id,
              warehouseName: o.warehouse.name,
              clientId: o.client_id,
              clientName: o.entity.name,
              orderId: o.order_id,
              itemType: o.item_type,
              status: o.status,
              quantity: o.quantity,
              deletedBy: o.deleted_by,
              deletedDatetime: o.deleted_datetime,
              deletedCause: o.deleted_cause,
              description: o.description,
              imageFilename: o.image_filename,
              contentFileName: o.content_filename,
              manufacter: o.manufacter,
              model: o.model,
              partNumber: o.part_number,
              serialNumber: o.serial_number,
              uaNumber: o.ua_number,
              condition: o.condition,
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
            format.json { render json: @items }
          end
        end
      end

    end
  end
end
