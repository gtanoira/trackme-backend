module Api
  module V1

    class EventTypesController < ApplicationController
      #before_action :authenticate_user!

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @event_types = EventType.includes(:tracking_milestone).order(name: :asc).all.map do |o|
            {
              id: o.id,
              name: o.name,
              trackingMilestoneId: o.tracking_milestone_id,
              trackingMilestoneName: o.tracking_milestone.name,
              trackingMilestoneCssColor: o.tracking_milestone_css_color
            }
          end
          
          respond_to do |format|
            format.html
            format.json { render json: @event_types }
          end
        end
      end

    end

  end
end
