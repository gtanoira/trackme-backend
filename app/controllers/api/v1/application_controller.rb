# Application Controller for API access, using devise_token_auth
# for authentication
module Api
  module V1
    class ApplicationController < ActionController::Base
      puts '*** API/V1'
      protect_from_forgery with: :exception
    
      include Knock::Authenticable
      undef_method :current_user
        
      def is_admin?
        signed_in? ? current_user.admin : false
      end
    end
  end
end