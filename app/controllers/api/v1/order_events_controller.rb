module Api
  module V1

    class OrderEventsController < ApplicationController

      # Helpers
      helper ApisHelper
      helper AuthorizationsHelper

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
