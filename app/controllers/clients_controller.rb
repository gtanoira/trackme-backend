class ClientsController < ApplicationController
  protect_from_forgery with: :exception

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
  # Read Client from a Excel file
  # 
  # HTTP method: POST
  # @params:
  #    file (string): name of the file (excel) uploaded
  #
  def import
    begin
      result   = Client.import(params[:file])
      self.setUrlLogFile(result[:logFile])
      redirect_to utilities_clients_path, notice: 'Clients imported: ' + result[:message]
    rescue => e
      puts "ERROR BACKTRACE:"
      puts e.backtrace
      redirect_to utilities_clients_path, alert: e.to_s
    end
  end

  # ******************************************************************************
  # Ask to import Client from a Excel File
  #
  # HTTP method: GET
  #
  def utilities
  end

end
