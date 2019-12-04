module AuthorizationsHelper

  # Get all the companies a user have access
  # @return (list): 
  #   [ 1, 3, 23, ...]  if have access
  #   [-1]  if no access
  def get_user_companies(user_id)
  
    # get user authorizations
    user_record = User.select(:authorizations).find(user_id)
    user_authorizations = JSON.parse(user_record.authorizations)

    if user_authorizations.has_key?("companiesAllow") then
      if user_authorizations['companiesAllow'].empty? then
        return [-1]
      else
        return user_authorizations['companiesAllow']
      end
    else
      return [-1]
    end
  end

  # Get all the clients a user have access
  # @return (array<numbers>): 
  #   [ 1, 3, 23, ...]  if have access
  #   [-1]  if no access
  def get_user_clients(user_id)
  
    # get user authorizations
    user_record = User.select(:authorizations).find(user_id)
    user_authorizations = JSON.parse(user_record.authorizations)

    if user_authorizations.has_key?("clientsAllow") then
      if user_authorizations['clientsAllow'].empty? then
        return [-1]
      else
        return user_authorizations['clientsAllow']
      end
    else
      return [-1]
    end
  end

end
