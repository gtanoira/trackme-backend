module Api
  module V1

    class CustomerOrderEventsController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Add a new event to a customer order
      #
      # URL: /api/v1/customer_orders/:customer_order_id/events.json
      # HTTP method: POST
      # Request Body: (JSON) order_event data
      #
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          begin
            customer_order_event = CustomerOrderEvent.new
            customer_order_event.event_type_id     = params['eventTypeId']
            customer_order_event.user_id           = params['userId']
            customer_order_event.customer_order_id = params['customerOrderId']
            customer_order_event.event_datetime    = params['eventDatetime']
            customer_order_event.event_scope       = params['eventScope']
            customer_order_event.observations      = params['observations']
            customer_order_event.save!

            respond_to do |format|
              format.json { render json: {message: 'Event saved.'} }
            end

          rescue => e
            puts "Error #{e.class}: #{e.message}"
            puts "ERROR BACKTRACE:"
            puts e.backtrace
            respond_to do |format|
              format.json { render json: {message: 'Error saving the event to the order',
                                          extraMsg: e.message} }
            end
          end

        end
      end

      # ******************************************************************************
      # Get all the Events of a Order
      # 
      # URL: /api/v1/customer_orders/:customer_order_id/events.json
      # HTTP method: GET
      # Request Body: (Array of JSONs) events of an order
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          if params['customer_order_id'] == 0 then
            @order_events = []

          else
            @order_events = CustomerOrderEvent.includes(:event_type, :user).where(customer_order_id: params['customer_order_id']).map do |o|
              {
                id:              o.id,
                eventTypeId:     o.event_type_id,
                eventTypeName:   o.event_type.name,
                userid:          o.user_id,
                userName:        "#{o.user.last_name}, #{o.user.first_name}",
                customerOrderId: o.customer_order_id,
                eventDatetime:   o.event_datetime,
                observations:    o.observations,
                eventScope:      o.event_scope
              }
            end
          end

          respond_to do |format|
            format.json { render json: @order_events }
          end
        end
      end

    end
  end
end