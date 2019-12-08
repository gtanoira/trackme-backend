module Api
  module V1

    class OrderEventsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # Helpers
      helper ApisHelper
      helper AuthorizationsHelper

      # Create a new order Event
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the order ID
          order_id = params[:order_id].to_i

          # Save the order event data
          begin
            order_event_data = OrderEvent.new
            order_event_data.event_id = params['eventId']
            order_event_data.user_id = params['userId']
            order_event_data.order_id = order_id
            order_event_data.scope = params['scope']
            order_event_data.observations = params['observations']
            order_event_data.save!

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

      # Get last event of an order 
      def get_last_event
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the order ID
          order_id = params[:order_id].to_i

          @event = OrderEvent
            .includes(:user, :order)
            .joins(event: :tracking_milestone)
            .where(order_id: order_id)
            .order(created_at: :desc)
            .first

          if @event.blank? || @event.nil? then
            @last_event = {
              orderId: nil,
              createdAt: nil,
              placeOrder: 1,
              message: 'No events yet',
              shipmentMethod: 'A'
            }
          else
            @last_event = {
              orderId: @event.order_id,
              createdAt: @event.created_at,
              placeOrder: @event.event.tracking_milestone.place_order,
              message: @event.event.name,
              shipmentMethod: @event.order.shipment_method
            }
          end
          
          respond_to do |format|
            format.json { render json: @last_event }
          end
        end
      end

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the order ID
          order_id = params[:order_id].to_i

          @order_events = OrderEvent
            .includes(:user)
            .joins(event: :tracking_milestone)
            .where(order_id: order_id)
            .order(created_at: :desc)
            .map do |o|
            {
              id: o.id,
              eventId: o.event_id,
              eventName: o.event.name,
              userId: o.user_id,
              userName: "#{o.user.first_name} #{o.user.last_name}",
              orderId: o.order_id,
              createdAt: o.created_at,
              observations: o.observations,
              scope: "#{o.scope == nil || o.scope.blank? ? o.event.scope : o.scope}",
              placeOrder: o.event.tracking_milestone.place_order
            }
          end
          
          respond_to do |format|
            format.json { render json: @order_events }
          end
        end
      end

    end

  end
end
