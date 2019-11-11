class ItemsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session

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
  # Import Items data from an Excel file
  # 
  # URL: /items/import
  # HTTP method: POST
  # @params: string>:  file (string): name of the file (excel) uploaded
  #
  def import
    begin
      result   = Item.import(params[:file])
      self.setUrlLogFile(result[:logFile])
      redirect_to utilities_items_path, notice: 'Items imported: ' + result[:message]
    rescue => e
      puts "ERROR BACKTRACE:"
      puts e.backtrace
      redirect_to utilities_items_path, alert: e.to_s
    end
  end

  # ******************************************************************************
  # Upload form to ask to import Items data from an Excel File
  #
  # URL: /items/utilities
  # HTTP method: GET
  #
  def utilities
  end

end
