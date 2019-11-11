class CustomerOrdersController < Api::V1::ApplicationController
  #skip_before_action :verify_authenticity_token

  # Define variables for cross-method's
  @@UrlLogFile = nil    # URL of the LOG errors file (URL path NOT OS path)

  # Set URL LOG filename
  def setUrlLogFile(logFileName)
    @@UrlLogFile = logFileName
  end

  # Get URL LOG filename
  def getUrlLogFile
    @@UrlLogFile
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
  # Read Customer Orders data from a Excel file
  # 
  # URL: /api/customer_orders/import
  # HTTP method: POST
  # @params:
  #           file (string): name of the file (excel) uploaded
  #
  def import
    begin
      result   = CustomerOrder.import(params[:file])
      self.setUrlLogFile(result[:logFile])
      redirect_to utilities_customer_orders_path, notice: 'Customer Orders imported: ' + result[:message]
    rescue => e
      puts "ERROR BACKTRACE:"
      puts e.backtrace
      redirect_to utilities_customer_orders_path, alert: e.to_s
    end
  end

  # ******************************************************************************
  # Ask to import Customer Orders data from a Excel File
  #
  # URL: /custorder/utilities
  # HTTP method: GET
  #
  def utilities
  end

end
