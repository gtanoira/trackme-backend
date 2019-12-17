class OrdersController < ApplicationController
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
  # Read Client Orders data from a Excel file
  # 
  # URL: /api/client_orders/import
  # HTTP method: POST
  # @params:
  #           file (string): name of the file (excel) uploaded
  #
  def import
    begin
      result = Order.import(params[:file])
      self.setUrlLogFile(result[:logFile])
      redirect_to utilities_orders_path, notice: 'Orders imported: ' + result[:message]
    rescue => e
      puts "ERROR BACKTRACE:"
      puts e.backtrace
      redirect_to utilities_orders_path, alert: e.to_s
    end
  end

  # ******************************************************************************
  # Ask to import Client Orders data from a Excel File
  #
  # URL: /custorder/utilities
  # HTTP method: GET
  #
  def utilities
  end

end
