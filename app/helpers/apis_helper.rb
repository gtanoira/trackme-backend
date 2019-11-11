module ApisHelper
  
  # ********************************************************************************************
  # Writes all the API calls and their responses to a LOG file.
  # The LOG file is stored in the public/downloads path with the name api_requests_YYYYMM.log
  # Each api_request_YYYYMM.log file stores all the api requests received in a month.
  #
  # @return: nil
  def API_save_to_log(api_name, req_params, result, user_data = nil )

    log_name = File.join(Rails.root, 'public/downloads', 'api_requests_' + DateTime.now.strftime("%Y%m") + '.log')
    log_file = File.open(log_name, 'a')
    log_file.puts ''
    log_file.puts '*****************************************************************************************'
    log_file.puts api_name + ' -> ' + DateTime.now.strftime("%Y-%m-%d %H:%M:%S") +' by '+ ((user_data == nil) ? 'No user identified' : user_data)
    log_file.puts 'PARAMS:'
    log_file.puts req_params
    log_file.puts 'RESULT:'
    log_file.puts result
    log_file.close

    return nil
 
  end

  # ********************************************************************************************
  # Validates the JWT token received by the caller of an API request
  #
  # @param: request
  # 
  # @return: boolean: Yes, No the token is valid
  # @return: string: message
  #
  def API_validate_token(request)

    # Get data from request
    url_path = request.headers['REQUEST_PATH']
    remote_addr = request.headers['REMOTE_ADDR']

    begin

      # Get the token
      token = request.headers['Authorization']
      
      # Token exists
      if token != nil && token !='' && token['jwt']
        jwt_token = JWT.decode request.headers['Authorization'][4..-1], Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }
        #user_id = jwt_token[0]["sub"]
        #usercheck = User.find(user_id)
        return true, 'token ok'
      else
        API_save_to_log(url_path, params.to_s, 'TRK-0007(E): non-existent token.')
        return false, 'TRK-0007(E): non-existent token.'
      end

    rescue JWT::ExpiredSignature
      # Grabar en el LOG
      API_save_to_log(url_path, params.to_s, 'TRK-0005(E): the session has expired, restart session.')
      return false, 'TRK-0005(E): the session has expired, restart session.'
    rescue  JWT::DecodeError
      # Grabar en el LOG
      API_save_to_log(url_path, params.to_s, 'TRK-0006(E): invalid token.')
      return false, 'TRK-0006(E): invalid token.'
    rescue  JWT::VerificationError
      # Grabar en el LOG
      API_save_to_log(url_path, params.to_s, 'TRK-0006(E): invalid token.')
      return false, 'TRK-0006(E): invalid token.'
    end
  
  end

  # ********************************************************************************************
  # Retrives the user_id from the JWT token
  #
  # @param: string: JWT token. The token MUST be valid
  # 
  # @return: number: user ID (0 (cero): invalid user )
  #
  def API_get_user_from_token(jwt_token)

    begin
      token_decoded = JWT.decode jwt_token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }
      user_id = token_decoded[0]["sub"]
      return user_id
    rescue
      # Invalid user
      return 0
    end
  
  end

end

