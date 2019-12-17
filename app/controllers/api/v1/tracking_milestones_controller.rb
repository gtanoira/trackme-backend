module Api
  module V1

    class TrackingMilestonesController < ApplicationController
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

          @trk_milestones = TrackingMilestone
            .joins(account: :users)
            .where("users.id = #{user_id}")
            .order(place_order: :asc)
            .map do |o|
            {
              id: o.id,
              name: o.name,
              placeOrder: o.place_order,
              cssColor: o.css_color,
              description: o.description
            }
          end
          
          respond_to do |format|
            format.json { render json: @trk_milestones }
          end
        end
      end

    end

  end
end
