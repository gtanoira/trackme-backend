module Api
  module V1

    class OrdersController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Get the next Company Order's No. 
      # 
      # Method: GET
      # Query params: 
      #   companyId: id for company to find the last order no.
      # Response: 
      #   Content-type: text/html
      #   body: (number) => last order for the company selected
      # 
      def get_last_order
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          xcompany_id = params[:company_id].to_i
          @last_order = Order
                      .select('order_no as last_order')
                      .order(order_no: :desc)
                      .limit(1)
                      .find_by(company_id: xcompany_id)
          @last_order = (@last_order.blank?)? 0 : @last_order
          
          respond_to do |format|
            format.json { render json: @last_order }
          end
        end
      end

      # ******************************************************************************
      # List all Orders (for Grid)
      # 
      # HTTP method: GET
      # Response
      # => Content-type: application/json;
      # => Body: JSON file
      #
      def get_orders_grid
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @grid_orders = Order.includes(:entity, :company).map do |o|
            {
              id: o.id,
              companyName: o.company.name,
              clientName: o.entity.name,
              orderNo: o.order_no,
              type: o.type,
              clientRef: o.client_ref,
              orderDatetime: o.order_datetime,
              observations: o.observations,
              orderStatus: o.order_status,
              pieces: o.pieces,
              fromEntity: o.from_entity,
              toEntity: o.to_entity,
            }
          end
          respond_to do |format|
            format.json { render json: @grid_orders }
          end
        end
      end

    end
  end
end
