module Api
  module V1

    class WarehouseReceiptsController < Api::V1::ApplicationController
      #before_action :authenticate_user!
      #protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Add a new WarehouseReceipt (WR) into the Data Base
      #
      # HTTP method: POST
      # Query params:  none
      # Request Body: (JSON) WR data
      #
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          begin

            # Get last order no. for company
            new_wr_no = Order.get_last_order_no(params['companyId'])

            # Save WR data
            wr_order = WarehouseReceipt.new
            # Block General
            wr_order.company_id = params['companyId']
            wr_order.client_id = params['clientId']
            wr_order.order_no = new_wr_no + 1
            wr_order.applicant_name = params['applicantName']
            wr_order.client_ref = params['clientRef']
            wr_order.delivery_datetime = params['deliveryDatetime']
            wr_order.eta = params['eta']
            wr_order.incoterm = params['incoterm']
            wr_order.legacy_order_no = params['legacyOrderNo']
            wr_order.observations = params['observations']
            wr_order.order_datetime = params['orderDatetime']
            wr_order.status = params['status']
            wr_order.order_type = params['orderType']
            wr_order.pieces = params['pieces']
            wr_order.shipment_method = params['shipmentMethod']
            wr_order.third_party_id = params['thirdPartyId']
            # Block Shipper
            wr_order.from_entity = params['fromEntity']
            wr_order.from_address1 = params['fromAddress1']
            wr_order.from_address2 = params['fromAddress2']
            wr_order.from_city = params['fromCity']
            wr_order.from_zipcode = params['fromZipcode']
            wr_order.from_state = params['fromState']
            wr_order.from_country_id = params['fromCountryId']
            wr_order.from_contact = params['fromContact']
            wr_order.from_email = params['fromEmail']
            wr_order.from_tel = params['fromTel']
            # Block Consignee
            wr_order.to_entity = params['toEntity']
            wr_order.to_address1 = params['toAddress1']
            wr_order.to_address2 = params['toAddress2']
            wr_order.to_city = params['toCity']
            wr_order.to_zipcode = params['toZipcode']
            wr_order.to_state = params['toState']
            wr_order.to_country_id = params['toCountryId']
            wr_order.to_state = params['toState']
            wr_order.to_contact = params['toContact']
            wr_order.to_email = params['toEmail']
            wr_order.to_tel = params['toTel']
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
              format.json { render json: {message: "Warehouse Receipt saved. WR No. #{r_order.order_no.to_s}",
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
      end


      # ******************************************************************************
      # Update a existing WR in the Data Base
      #
      # HTTP method: PATCH or PUT
      # Query params:  none
      # Request Body: (JSON) WR data fields only
      #
      def update
        rec_id = params[:id].to_i
        begin
          wr = WarehouseReceipt.find_by_id(rec_id)
          wr.update(
            applicant_name:  params['applicantName'],
            client_ref:      params['clientRef'],
            eta:             params['eta'],
            incoterm:        params['incoterm'],
            observations:    params['observations'],
            status:          params['status'],
            order_type:      params['orderType'],
            pieces:          params['pieces'],
            shipment_method: params['shipmentMethod'],
            third_party_id:  params['thirdPartyId'],
            # Shipper
            from_entity:     params['fromEntity'],
            from_address1:   params['fromAddress1'],
            from_address2:   params['fromAddress2'],
            from_city:       params['fromCity'],
            from_zipcode:    params['fromZipcode'],
            from_state:      params['fromState'],
            from_country_id: params['fromCountryId'],
            from_contact:    params['fromContact'],
            from_email:      params['fromEmail'],
            from_tel:        params['fromTel'],
            # Consignee
            to_entity:       params['toEntity'],
            to_address1:     params['toAddress1'],
            to_address2:     params['toAddress2'],
            to_city:         params['toCity'],
            to_zipcode:      params['toZipcode'],
            to_state:        params['toState'],
            to_country_id:   params['toCountryId'],
            to_contact:      params['toContact'],
            to_email:        params['toEmail'],
            to_tel:          params['toTel'],
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
            format.json { render json: {message: "Warehouse Receipt ##{params['orderNo'].to_s} saved.",
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