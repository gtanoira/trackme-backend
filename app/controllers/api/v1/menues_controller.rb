module Api
  module V1

    class MenuesController < ApplicationController
      #before_action :authenticate_user

      # Get all the records 
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @menues = Menues.order(pgm_group: :asc, title: :asc).all.map do |o|
            {
              pgmId: o.pgm_id,
              alias: o.alias,
              title: o.title,
              pgmGroup: o.pgm_group,
              color: o.color
            }
          end
          respond_to do |format|
            format.json { render json: @menues }
          end
        end
      end
    end

  end
end
