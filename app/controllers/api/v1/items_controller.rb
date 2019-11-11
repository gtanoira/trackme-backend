module Api
  module V1

    class ItemsController < Api::V1::ApplicationController
      #skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Get all Items data 
      # 
      # URL: /api/v1/items/
      # HTTP method: GET
      # Response
      # => Content-type: application/json;
      # => Body: JSON file
      #
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @items = Item.includes(:entity, :company, :internal_order).map do |o|
            {
              id: o.id,
              companyId: o.company_id,
              cmpanyName: o.company.name,
              customerId: o.customer_id,
              customerName: o.entity.name,
              itemId: o.item_id,
              internalOrderNo: "#{o.internal_order.order_type}-#{o.internal_order.order_no}",
              itemType: o.item_type,
              status: o.status,
              deletedBy: o.deleted_by,
              deletedCause: o.deleted_cause,
              manufacter: o.manufacter,
              model: o.model,
              partNumber: o.part_number,
              serialNumber: o.serial_number,
              uaNumber: o.ua_number,
              condition: o.condition,
              contents: o.contents,
              unitLength: o.unit_length,
              width: o.width,
              height: o.height,
              length: o.length,
              unitWeigth: o.unit_weight,
              weight: o.weight,
              unitVolume: o.unit_volume,
              volumeWeight: o.volume_weight
            }
          end
          respond_to do |format|
            format.json { render json: @items }
          end
        end
      end


      # ******************************************************************************
      # Get an Item by item_id
      # 
      # URL: /api/v1/items/[:id].json
      # Method: GET
      # URL params: 
      #   itemId: item id. This is the record ID(id) not the item_id
      # Response: 
      #   Content-type: application/json
      #   body: (JSON) => order selected by order_id
      # 
      def show
        rec_id = params[:id].to_i
        begin
          o = Item.find(rec_id)
          @rec = {  
              id: o.id,
              companyId: o.company_id,
              customerId: o.customer_id,
          }
        rescue ActiveRecord::RecordNotFound
          @rec = {}
        end

        respond_to do |format|
          format.json { render json: @rec }
        end
      end


      # ******************************************************************************
      # Update an existing item in the Data Base
      #
      # URL: /api/v1/items/[:id]
      # HTTP method: PATCH
      # Query params:  none
      # Request Body: (JSON) item data fields only
      #
      def update
        rec_id = params[:id].to_i
        begin
          Item.update(
            rec_id,
          )

          puts '*** ORDEN SALVADA / recId: ' + rec_id.to_s + ' / OrderId: ' + params['orderNo'].to_s

          respond_to do |format|
            format.json { render json: {message: 'Item saved. Item ID ' + params['id'].to_s,
                                        orderId: rec_id,
                                        id: params['id']} }
          end

        rescue => e
          puts "ERROR BACKTRACE:"
          puts e.backtrace
          respond_to do |format|
            format.json { render json: {message: 'Error saving the item (' + params['id'].to_s + ')',
                                        extraMsg: e.message} }
          end
        end

      end

    end
  end
end
