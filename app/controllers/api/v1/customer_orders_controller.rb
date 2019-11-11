module Api
  module V1

    class CustomerOrdersController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Add a new order into the Data Base
      #
      # URL: /api/customer_orders/
      # HTTP method: POST
      # Query params:  none
      # Request Body: (JSON) customer order data
      #
      def create
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          begin

            # Get last order no. for company
            new_order_no = get_last_order_no(params['companyId'])
            if new_order_no != 0 then
              customer_order = CustomerOrder.new
              customer_order.company_id      = params['companyId']
              customer_order.customer_id     = params['customerId']
              customer_order.order_no        = new_order_no + 1
              customer_order.order_date      = params['orderDate']
              customer_order.observations    = params['observations']
              customer_order.pieces          = params['pieces']
              customer_order.cust_ref        = params['custRef']
              customer_order.order_type      = params['orderType']
              customer_order.order_status    = params['orderStatus']
              customer_order.applicant_name  = params['applicantName']
              customer_order.old_order_no    = params['oldOrderNo']
              customer_order.incoterm        = params['incoterm']
              customer_order.shipment_method = params['shipmentMethod']
              customer_order.eta             = params['eta']
              customer_order.delivery_date   = params['deliveryDate']
              customer_order.events_scope    = params['eventsScope']
              customer_order.third_party_id  = params['thirdPartyId']
              customer_order.from_entity     = params['fromEntity']
              customer_order.from_address1   = params['fromAddress1']
              customer_order.from_address2   = params['fromAddress2']
              customer_order.from_city       = params['fromCity']
              customer_order.from_zipcode    = params['fromZipcode']
              customer_order.from_state      = params['fromState']
              customer_order.from_country_id = params['fromCountryId']
              customer_order.from_contact    = params['fromContact']
              customer_order.from_email      = params['fromEmail']
              customer_order.from_tel        = params['fromTel']
              customer_order.to_entity       = params['toEntity']
              customer_order.to_address1     = params['toAddress1']
              customer_order.to_address2     = params['toAddress2']
              customer_order.to_city         = params['toCity']
              customer_order.to_zipcode      = params['toZipcode']
              customer_order.to_state        = params['toState']
              customer_order.to_country_id   = params['toCountryId']
              customer_order.to_contact      = params['toContact']
              customer_order.to_email        = params['toEmail']
              customer_order.to_tel          = params['toTel']
              customer_order.save!

              puts '*** ORDEN SALVADA: ' + customer_order.order_no.to_s

              respond_to do |format|
                format.json { render json: {message: 'Customer order saved. Order No.' + customer_order.order_no.to_s,
                                            id: customer_order.id,
                                            orderNo: customer_order.order_no} }
              end

            else

              respond_to do |format|
                format.json { render json: {message: 'Error saving the new customer order. Not able to obtain a order no.',
                                            id: 0,
                                            orderNo: 0} }
              end
            end


          rescue => e
            puts "ERROR BACKTRACE:"
            puts e.backtrace
            respond_to do |format|
              format.json { render json: {message: 'Error saving the customer order no. ' + customer_order.order_no.to_s,
                                          extraMsg: e.message} }
            end
          end
        end
      end

      # ******************************************************************************
      # Get the next Customer Order No.
      # 
      # Method: GET
      # Query params: 
      #   copmanyId: id for company to find the last order no.
      # Response: 
      #   Content-type: text/html
      #   body: (number) => last order for the company selected
      # 
      # API access
      def get_last_order
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          xcompany_id = params[:company_id].to_i
          @last_order = CustomerOrder
                      .select('order_no as last_order')
                      .order(order_no: :desc)
                      .limit(1)
                      .find_by(company_id: xcompany_id)
          @last_order = (@last_order.blank?)? 0 : @last_order
          
          respond_to do |format|
            format.json { render json: @last_order }
          end
        end
      end

      # ******************************************************************************
      # Get the last Customer Order No. by a specific company id
      # 
      # Parameters;
      #   pcompany_id: company id to find the last order no.
      # Return: 
      #   last_order (number): last order No. for the company selected (returns 0 (cero) if there is no last order for the company)
      #
      def get_last_order_no(pcompany_id)
        @last_order = CustomerOrder
                      .select(:order_no)
                      .order(order_no: :desc)
                      .limit(1)
                      .find_by_company_id(pcompany_id)

        last_order = (@last_order.blank?)? 0 : @last_order.order_no
        return last_order
      end

      # ******************************************************************************
      # List all Customer Orders data with a grid using ag-grid
      # 
      # URL: /api/v1/customer_orders/
      # HTTP method: GET
      # Response
      # => Content-type: application/json;
      # => Body: JSON file
      #
      def index
        token_ok, token_error = helpers.API_validate_token(request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          @customer_orders = CustomerOrder.includes(:entity, :country).map do |o|
            {
              id: o.id,
              companyId: o.company_id,
              customerId: o.customer_id,
              customerName: o.entity.name,
              orderNo: o.order_no,
              orderDate: o.order_date,
              observations: o.observations,
              custRef: o.cust_ref,
              orderType: o.order_type,
              orderStatus: o.order_status,
              cancelDate: o.cancel_date,
              cancelUser: o.cancel_user,
              applicantName: o.applicant_name,
              oldOrderNo: o.old_order_no,
              incoterm: o.incoterm,
              shipmentMethod: o.shipment_method,
              eta: o.eta,
              deliveryDate: o.delivery_date,
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
            }
          end
          respond_to do |format|
            format.json { render json: @customer_orders }
          end
        end
      end

      # ******************************************************************************
      # Add a new Customer Order
      #
      # URL /custorder/new
      def new
      end


      # ******************************************************************************
      # Get a Customer Order by id
      # 
      # URL: /api/v1/customer_order/[:id].json
      # Method: GET
      # URL params: 
      #   id: customer order ID. This is the record ID(id) not the order no.(order_no)
      # Response: 
      #   Content-type: application/json
      #   body: (JSON) => order selected by order_id
      # 
      def show
        rec_id = params[:id].to_i
        begin
          o = CustomerOrder.find(rec_id)
          @rec = {  
              id: o.id,
              companyId: o.company_id,
              customerId: o.customer_id,
              orderNo: o.order_no,
              orderDate: o.order_date,
              observations: o.observations,
              custRef: o.cust_ref,
              orderType: o.order_type,
              orderStatus: o.order_status,
              cancelDate: o.cancel_date,
              cancelUser: o.cancel_user,
              applicantName: o.applicant_name,
              oldOrderNo: o.old_order_no,
              incoterm: o.incoterm,
              shipmentMethod: o.shipment_method,
              pieces: o.pieces,
              eta: o.eta,
              deliveryDate: o.delivery_date,
              thirdPartyId: o.third_party_id,
              eventsScope: o.events_scope,
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
              toEntity: o.to_entity,
              toAddress1: o.to_address1,
              toAddress2: o.to_address2,
              toCity: o.to_city,
              toZipcode: o.to_zipcode,
              toState: o.to_state,
              toCountryId: o.to_country_id,
              toContact: o.to_contact,
              toEmail: o.to_email,
              toTel: o.to_tel
          }
        rescue ActiveRecord::RecordNotFound
          @rec = {}
        end

        respond_to do |format|
          format.json { render json: @rec }
        end
      end


      # ******************************************************************************
      # Update a existing customer order in the Data Base
      #
      # URL: /api/v1/customer_orders/:id
      # HTTP method: PATCH
      # Query params:  none
      # Request Body: (JSON) customer order data fields only
      #
      def update
        rec_id = params[:id].to_i
        begin
          CustomerOrder.update(
            rec_id,
            # BLOCK: general
            order_date:      params['orderDate'],
            cust_ref:        params['custRef'],
            order_type:      params['orderType'],
            applicant_name:  params['applicantName'],
            incoterm:        params['incoterm'],
            shipment_method: params['shipmentMethod'],
            # Order Data
            order_status:    params['orderStatus'],
            old_order_no:    params['oldOrderNo'],
            # Events
            events_scope:    params['eventsScope'],
            # Observations
            observations:    params['observations'],
            pieces:          params['pieces'],
            # Other
            eta:             params['eta'],
            delivery_date:   params['deliveryDate'],
            third_party_id:  params['thirdPartyId'],
            # BLOCK: From
            from_entity:     params['fromEntity'],
            from_address1:   params['fromAddress1'],
            from_address2:   params['fromAddress2'],
            from_city:       params['fromCity'],
            from_zipcode:    params['fromZipcode'],
            from_state:      params['fromState'],
            from_country_id: params['fromCountryId'],
            # BLOCK: To
            to_entity:       params['toEntity'],
            to_address1:     params['toAddress1'],
            to_address2:     params['toAddress2'],
            to_city:         params['toCity'],
            to_zipcode:      params['toZipcode'],
            to_state:        params['toState'],
            to_country_id:   params['toCountryId']
          )

          puts '*** ORDEN SALVADA / recId: ' + rec_id.to_s + ' / OrderId: ' + params['orderNo'].to_s

          respond_to do |format|
            format.json { 
              render json: {
                message: 'Customer order saved. Order No. ' + params['orderNo'].to_s,
                orderId: rec_id,
                orderNo: params['orderNo']
              }
            }
          end

        rescue => e
          puts "ERROR BACKTRACE:"
          puts e.backtrace
          respond_to do |format|
            format.json { render json: {message: 'Error saving the customer order (' + params['orderNo'].to_s + ')',
                                        extraMsg: e.message} }
          end
        end

      end

    end
  end
end
