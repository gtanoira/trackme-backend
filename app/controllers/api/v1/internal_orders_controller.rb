class InternalOrdersController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session


  # ******************************************************************************
  # Get a WR by id
  # 
  # URL: /api/internal_orders/:id/items.json
  # Method: GET
  # URL params: 
  #   id: internal order ID. This is the record ID(id) not the order no.(order_no)
  # Response: 
  #   Content-type: application/json
  #   body: (JSON) => stock items of a internal order
  # 
  def items
    rec_id = params[:internal_order_id].to_i
    begin
      @items = Item.where(internal_order_id: rec_id).all.map do |o|
        {
          id: o.id,
          customerId: o.customer_id,
          companyId: o.company_id,
          itemId: o.item_id,
          itemType: o.item_type,
          status: o.status,
          deletedBy: o.deleted_by,
          deletedCause: o.deleted_cause,
          manufacter: o.manufacter,
          model: o.model,
          partNumber: o.part_number,
          serialNumber: o.serial_number,
          condition: o.condition,
          contents: o.contents,
          unitLength: o.unit_length,
          width: o.width,
          height: o.height,
          length: o.length,
          unitWeight: o.unit_weight,
          weight: o.weight,
          unitVolume: o.unit_volume,
          volumeWeight: o.volume_weight,
          internalorderId: o.internal_order_id
        }
      end
     
      respond_to do |format|
        format.html
        format.json { render json: @items }
      end
    rescue ActiveRecord::RecordNotFound
      @items = []
    end
  end

end
