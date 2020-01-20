module Api
  module V1

    class OrdersController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # List all Orders (for Grid)
      # 
      # HTTP method: GET
      # Response
      # => Content-type: application/json;
      # => Body: JSON file
      #
      def get_orders_grid
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else

          # Get the user_id
          user_id = helpers.API_get_user_from_token(request)
          # Get allow companies
          company_ids = helpers.get_user_companies(user_id)
          # Get allow clients
          client_ids = helpers.get_user_clients(user_id)

          if company_ids == [-1] then
            @grid_orders = Order
              .joins(company: [{ account: :users }])
              .where("users.id = #{user_id}")
              .where("orders.client_id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
              .includes(:entity)
          else
            @grid_orders = Order
              .where("orders.company_id IN (#{company_ids.join(',')}) OR #{company_ids == [-1]}")
              .where("orders.client_id IN (#{client_ids.join(',')}) OR #{client_ids == [-1]}")
              .includes(:entity, :company)
          end
          
          @rtn_json = @grid_orders.map do |o|
            {
              id: o.id,
              companyName: o.company.name,
              clientName: o.entity.name,
              clientAlias: o.entity.alias,
              orderNo: o.order_no,
              type: o.type,
              clientRef: o.client_ref,
              orderDatetime: o.order_datetime,
              observations: o.observations,
              status: o.status,
              pieces: o.pieces,
              fromEntity: o.from_entity,
              toEntity: o.to_entity,
            }
          end

          respond_to do |format|
            format.json { render json: @rtn_json }
          end
        end
      end

      # ******************************************************************************
      # Get an order by id
      # 
      # HTTP method: GET
      # Response
      # => Content-type: application/json;
      # => Body: JSON file
      #
      def show
        # Validate token
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          rec_id = params[:id].to_i
          begin
            o = Order.includes(:entity, :company).find(rec_id)
            @rec = { 
              id: o.id,
              companyId: o.company_id,
              companyName: o.company.name,
              clientId: o.client_id,
              clientName: o.entity.name,
              orderNo: o.order_no,
              type: o.type,
              applicantName: o.applicant_name,
              cancelDatetime: o.cancel_datetime,
              cancelUser: o.cancel_user,
              clientRef: o.client_ref,
              deliveryDatetime: o.delivery_datetime,
              eta: o.eta,
              incoterm: o.incoterm,
              legacyOrderNo: o.legacy_order_no,
              observations: o.observations,
              orderDatetime: o.order_datetime,
              status: o.status,
              orderType: o.order_type,
              pieces: o.pieces,
              shipmentMethod: o.shipment_method,
              thirdPartyId: o.third_party_id,
              # FROM
              fromEntity: o.from_entity,
              fromAddress1: o.from_address1,
              fromAddress2: o.from_address2,
              fromCity: o.from_city,
              fromZipcode: o.from_zipcode,
              fromState: o.from_state,
              fromCountryId: o.from_country_id,
              fromContact: o.from_contact,
              fromEmail: o.from_email,
              fromTel: o.from_tel,
              # TO
              toEntity: o.to_entity,
              toAddress1: o.to_address1,
              toAddress2: o.to_address2,
              toCity: o.to_city,
              toZipcode: o.to_zipcode,
              toState: o.to_state,
              toCountryId: o.to_country_id,
              toContact: o.to_contact,
              toEmail: o.to_email,
              toTel: o.to_tel,
              # GROUND
              groundEntity: o.ground_entity,
              groundBookingNo: o.ground_booking_no,
              groundDepartureCity: o.ground_departure_city,
              groundDepartureDate: o.ground_departure_date,
              groundArrivalCity: o.ground_arrival_city,
              groundArrivalDate: o.ground_arrival_date,
              # AIR
              airEntity: o.air_entity,
              airWaybillNo: o.air_waybill_no,
              airDepartureCity: o.air_departure_city,
              airDepartureDate: o.air_departure_date,
              airArrivalCity: o.air_arrival_city,
              airArrivalDate: o.air_arrival_date,
              # SEA
              seaEntity: o.sea_entity,
              seaBillLandingNo: o.sea_bill_landing_no,
              seaBookingNo: o.sea_booking_no,
              seaContainersNo: o.sea_containers_no,
              seaDepartureCity: o.sea_departure_city,
              seaDepartureDate: o.sea_departure_date,
              seaArrivalCity: o.sea_arrival_city,
              seaArrivalDate: o.sea_arrival_date
            }
          rescue ActiveRecord::RecordNotFound
            @rec = {}
          end

          respond_to do |format|
            format.json { render json: @rec }
          end
        end
      end
    end
  end
end
