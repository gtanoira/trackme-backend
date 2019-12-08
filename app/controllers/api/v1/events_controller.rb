module Api
  module V1

    class EventsController < ApplicationController
      #before_action :authenticate_user!

      # Helpers
      helper ApisHelper
      helper AuthorizationsHelper

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)

          @events = Event
            .joins(:account)
            .joins("INNER JOIN users ON users.account_id = accounts.id AND users.id = #{user_id}")
            .includes(:tracking_milestone)
            .order("tracking_milestones.place_order", "tracking_milestones.name", name: :asc)
            .map do |o|
            {
              id: o.id,
              name: o.name,
              scope: o.scope,
              trackingMilestoneId: o.tracking_milestone_id,
              trackingMilestoneName: o.tracking_milestone.name,
              trackingMilestonePlaceOrder: o.tracking_milestone.place_order,
              trackingMilestoneCssColor: o.tracking_milestone.css_color
            }
          end
          
          respond_to do |format|
            format.html
            format.json { render json: @events }
          end
        end
      end

    end

  end
end
