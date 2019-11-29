module Api
  module V1

    class WarehouseReceiptsController < Api::V1::ApplicationController
      #before_action :authenticate_user!
      #protect_from_forgery with: :null_session

      # ******************************************************************************
      # Add a new WarehouseReceipt (WR) into the Data Base
      #
      # URL: /api/v1/warehouse_receipts/
      # HTTP method: POST
      # Query params:  none
      # Request Body: (JSON) WR data
      #
      def create
        begin

          # Get last order no. for company
          new_wr_no = get_last_wr_no(params['companyId'])
          wr_order = WarehouseReceipt.new
          wr_order.company_id        = params['companyId']
          wr_order.customer_id       = params['customerId']
          wr_order.customer_order_id = params['customerOrderId']
          wr_order.order_no          = new_wr_no + 1
          wr_order.order_date        = params['orderDate']
          wr_order.observations      = params['observations']
          wr_order.order_type        = params['orderType']
          wr_order.order_status      = params['orderStatus']
          wr_order.shipment_method   = params['shipmentMethod']
          wr_order.eta               = params['eta']
          wr_order.delivery_date     = params['deliveryDate']
          wr_order.pieces            = params['pieces']
          # FROM
          wr_order.from_entity       = params['fromEntity']
          wr_order.from_address1     = params['fromAddress1']
          wr_order.from_address2     = params['fromAddress2']
          wr_order.from_city         = params['fromCity']
          wr_order.from_zipcode      = params['fromZipcode']
          wr_order.from_state        = params['fromState']
          wr_order.from_country_id   = params['fromCountryId']
          # TO
          wr_order.to_entity         = params['toEntity']
          wr_order.to_address1       = params['toAddress1']
          wr_order.to_address2       = params['toAddress2']
          wr_order.to_city           = params['toCity']
          wr_order.to_zipcode        = params['toZipcode']
          wr_order.to_state          = params['toState']
          wr_order.to_country_id     = params['toCountryId']
          wr_order.to_state          = params['toState']
          # GROUND
          wr_order.ground_entity         = params['groundEntity']
          wr_order.ground_booking_no     = params['groundBookingNo']
          wr_order.ground_departure_city = params['groundDepartureCity']
          wr_order.ground_departure_date = params['groundDepartureDate']
          wr_order.ground_arrival_city   = params['groundArrivalCity']
          wr_order.ground_arrival_date   = params['groundArrivalDate']
          # AIR
          wr_order.air_entity         = params['airEntity']
          wr_order.air_waybill_no     = params['airWaybillNo']
          wr_order.air_departure_city = params['airDepartureCity']
          wr_order.air_departure_date = params['airDepartureDate']
          wr_order.air_arrival_city   = params['airArrivalCity']
          wr_order.air_arrival_date   = params['airArrivalDate']
          # SEA
          wr_order.sea_entity          = params['seaEntity']
          wr_order.sea_bill_landing_no = params['seaBillLandingNo']
          wr_order.sea_booking_no      = params['seaBookingNo']
          wr_order.sea_containers_no   = params['seaContainersNo']
          wr_order.sea_departure_city  = params['seaDepartureCity']
          wr_order.sea_departure_date  = params['seaDepartureDate']
          wr_order.sea_arrival_city    = params['seaArrivalCity']
          wr_order.sea_arrival_date    = params['seaArrivalDate']
          wr_order.save!

          puts '*** WR ORDER SALVADA: ' + wr_order.order_no.to_s

          respond_to do |format|
            format.json { render json: {message: 'Warehouse Receipt saved. WR No.' + wr_order.order_no.to_s,
                                        orderId: wr_order.id,
                                        orderNo: wr_order.order_no},
                          :status => 200 }
          end

        rescue => e
          puts "*** WarehouseReceipt ERROR:"
          puts e.backtrace
          respond_to do |format|
            format.json { render json: {message: 'Error saving the warehouse receipt no. ' + wr_order.order_no.to_s,
                                        extraMsg: e.message},
                          :status => 404 }
          end
        end
      end


      # ******************************************************************************
      # Get the next WR Order No.
      # 
      # Method: GET
      # Query params: 
      #   companyId: id for company to find the last order no.
      # Response: 
      #   Content-type: text/html
      #   body: (number) => last order for the company selected
      # 
      # URL: /api/warehouse_receipts/lastorder/[companyId].json
      def get_last_order
        xcompany_id = params[:company_id].to_i
        @last_order = WarehouseReceipt
                    .select('order_no as last_order')
                    .order(order_no: :desc)
                    .limit(1)
                    .find_by(company_id: xcompany_id)
        @last_order = (@last_order.blank?)? 0 : @last_order
        
        respond_to do |format|
          format.json { render json: @last_order }
        end
      end


      # ******************************************************************************
      # Get the last WR Order No. by a specific company id
      # 
      # Parameters;
      #   pcompany_id: company id to find the last WR no.
      # Return: 
      #   last_order (number): last WR order No. for the company selected (returns 0 (cero) if there is no last WR order for the company)
      #
      def get_last_wr_no(pcompany_id)
        @last_order = WarehouseReceipt
                      .select(:order_no)
                      .order(order_no: :desc)
                      .limit(1)
                      .find_by_company_id(pcompany_id)

        last_order = (@last_order.blank?)? 0 : @last_order.order_no
        return last_order
      end


      # ******************************************************************************
      # Get all WR for a customer order
      # 
      # URL: /api/v1/warehouse_receipts/customer_order/get_ids
      # Method: GET
      # URL params: 
      #   customer_order_id: this is the record ID(id) not the order no.(order_no)
      # Response: 
      #   Content-type: application/json
      #   body: (JSON array) => [wr data]
      # 
      def get_all_wr_for_customer_order
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
        
          if params['customer_order_id'] == 0 then
            @wr_orders = []

          else
            begin
              @wr_orders = WarehouseReceipt.where(customer_order_id: params['customer_order_id']).map do |o|
                {
                  id: o.id,
                  orderNo: o.order_no
                }
              end
            rescue ActiveRecord::RecordNotFound
              @wr_orders = []
            end
    
          end

          respond_to do |format|
            format.json { render json: @wr_orders }
          end
        end
      end


      # ******************************************************************************
      # Update a existing WR in the Data Base
      #
      # URL: /api/warehouse_receipts/:id
      # HTTP method: PATCH or PUT
      # Query params:  none
      # Request Body: (JSON) WR data fields only
      #
      def update
        rec_id = params[:id].to_i
        begin
          WarehouseReceipt.update(
            rec_id,
            order_date:      params['orderDate'],
            observations:    params['observations'],
            order_type:      params['orderType'],
            order_status:    params['orderStatus'],
            shipment_method: params['shipmentMethod'],
            eta:             params['eta'],
            delivery_date:   params['deliveryDate'],
            # FROM
            from_entity:     params['fromEntity'],
            from_address1:   params['fromAddress1'],
            from_address2:   params['fromAddress2'],
            from_city:       params['fromCity'],
            from_zipcode:    params['fromZipcode'],
            from_state:      params['fromState'],
            from_country_id: params['fromCountryId'],
            # TO
            to_entity:       params['toEntity'],
            to_address1:     params['toAddress1'],
            to_address2:     params['toAddress2'],
            to_city:         params['toCity'],
            to_zipcode:      params['toZipcode'],
            to_state:        params['toState'],
            to_country_id:   params['toCountryId'],
            # GROUND
            ground_entity:         params['groundEntity'],
            ground_booking_no:     params['groundBookingNo'],
            ground_departure_city: params['groundDepartureCity'],
            ground_departure_date: params['groundDepartureDate'],
            ground_arrival_city:   params['groundArrivalCity'],
            ground_arrival_date:   params['groundArrivalDate'],
            # AIR
            air_entity:            params['airEntity'],
            air_waybill_no:        params['airWaybillNo'],
            air_departure_city:    params['airDepartureCity'],
            air_departure_date:    params['airDepartureDate'],
            air_arrival_city:      params['airArrivalCity'],
            air_arrival_date:      params['airArrivalDate'],
            # SEA
            sea_entity:            params['seaEntity'],
            sea_booking_no:        params['seaBookingNo'],
            sea_bill_landing_no:   params['seaBillLandingNo'],
            sea_containers_no:     params['seaContainersNo'],
            sea_departure_city:    params['seaDepartureCity'],
            sea_departure_date:    params['seaDepartureDate'],
            sea_arrival_city:      params['seaArrivalCity'],
            sea_arrival_date:      params['seaArrivalDate'],
          )

          puts '*** WR SALVADA / id: ' + rec_id.to_s + ' / OrderNo: ' + params['orderNo'].to_s

          respond_to do |format|
            format.json { render json: {message: 'Warehouse Receipt saved. WR No. ' + params['orderNo'].to_s,
                                        orderId: rec_id,
                                        orderNo: params['orderNo']} }
          end

        rescue => e
          puts "ERROR BACKTRACE:"
          puts e.backtrace
          respond_to do |format|
            format.json { render json: {message: 'Error saving the warehouse receipt No.: ' + params['orderNo'].to_s,
                                        extraMsg: e.message} }
          end
        end

      end

    end

  end
end