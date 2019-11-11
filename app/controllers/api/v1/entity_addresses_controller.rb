class EntityAddressesController < ApplicationController

   # Import Entities Addresses data from a Excel file
   def import
      EntityAddress.import(params[:file])
      redirect_to '/entities', notice: 'Entities imported'
   end

   # List all Addresses
   def index
      @addresses = EntityAddress
                    .includes(:country)
                    .order(:entity)
   end

   # Ask to import Entities data from a Excel File
   def migration
   end

  # Get all addresses for a HTML SELECT-OPTION case
  def select_options
    @addresses = EntityAddress.order(entity: :asc).map do |o|
      {
        id: o.id,
        name: o.entity
      }
    end

    respond_to do |format|
      format.json { render json: @addresses }
    end
  end

end
