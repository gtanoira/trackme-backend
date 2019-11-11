module ApplicationHelper

   # --------------------------------------------------------------------------------
   # Create the OPTIONs for the company SELECT tag
   def companyOptions(companyDefault)

      # Initialize variables
      htmlOutput = ''

      # Iterate over all companies and create the HTML OPTIONs
      begin
         Company.all.each do |company|
            htmlOutput << '<option value="' << company.id.to_s << '"' << ((company.id == companyDefault)? ' selected' : '') << '>' << company.name << '</option>'
         end
      rescue ActiveRecord::RecordNotFound => e
        # do nothing
      end

      return htmlOutput

   end


   # --------------------------------------------------------------------------------
   # Create the OPTIONs for the orderType SELECT tag
   def orderTypeOptions(orderType, orderTypeDefault)

      # Initialize variables
      htmlOutput = ''

      # Options for Customer Orders
      if orderType == 'customer' then
         options    = ['P', 'D', 'I', 'E']

         # Iterate over all companies and create the HTML OPTIONs
         options.each do |option|
            htmlOutput << '<option value="' << option << '"' \
                       << ((option == orderTypeDefault)? ' selected' : '') << '>' \
                       << case option \
                              when 'P' then 'PickUp by Company' \
                              when 'D' then 'Delivery by Company' \
                              when 'I' then 'PickUp by Client' \
                              when 'E' then 'Delivery by Client' \
                              else 'Error' \
                           end \
                       << '</option>'
         end

      # Options for Internal Orders
      else
         options    = ['A', 'G', 'B']

         # Iterate over all companies and create the HTML OPTIONs
         options.each do |option|
            htmlOutput << '<option value="' << option << '"' \
                       << ((option == orderTypeDefault)? ' selected' : '') << '>' \
                       << case option \
                              when 'A' then 'Air' \
                              when 'G' then 'Ground' \
                              when 'B' then 'Boat' \
                              else 'Error' \
                           end \
                       << '</option>'
         end

      end

      return htmlOutput

   end


   # --------------------------------------------------------------------------------
   # Return the complete text for the status of an order (orderStatus)
   def orderStatusDesc(orderStatus)

      # Initialize variables
      output = ''

      case orderStatus
         when 'P' then output = 'Pending'
         when 'C' then output = 'Confirmed'
         when 'F' then output = 'Finished'
         when 'A' then output = 'Cancelled'
         else 'Error'
      end

      return output

   end


   # --------------------------------------------------------------------------------
   # Return the Bootstrap class for the alerts
   def bootstrapAlert(flashAlert)
      output = ''
      case flashAlert
      when 'alert'   then output = 'danger'
      when 'error'   then output = 'danger'
      when 'notice'  then output = 'info'
      when 'success' then output = 'success'
      when 'warning' then output = 'warning'
      else output = 'info'
      end

      return output
   end


   # --------------------------------------------------------------------------------
   # Return the OS absolute path/directory for a certain type of static folder
   # All paths are return with the trailing /
   def staticPath(type)
      case type
      when 'log'    then '/public/downloads/logs/'
      when 'logs'   then '/public/downloads/logs/'
      when 'image'  then '/public/static/images/'
      when 'images' then '/public/static/images/'
      when 'css'    then '/public/static/css/'
      when 'js'     then '/public/static/js/'
      end
   end

end