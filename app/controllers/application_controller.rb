# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # JWT and Knock
  puts '*** AppCtrler 2'
  include Knock::Authenticable
  undef_method :current_user

  # That's all there is:
  #prepend_view_path Rails.root.join("frontend")
  helper_method :set_current_user

  # That's all there is:
  #prepend_view_path Rails.root.join("frontend")
  #helper_method :set_current_user

  # Downloads of files to the client's pc
  # @param type   (string): type of download files (log, etc)
  # @param id     (String): name of the file without the extension
  # @param format (string): extension of the filename
  #
  def download
    send_file(
      Rails.root.to_s + ApplicationController.helpers.staticPath(params[:type]) + params[:id]+'.'+params[:format],
      filename: params[:id]+'.'+params[:format],
      disposition: "attachment"
    )
  end

  # Sets current_user to all other Controllers
  def set_current_user
    User.current = current_user
  end

end