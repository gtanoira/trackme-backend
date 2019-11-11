class CustomerOrder < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :entity,  class_name: 'Entity',     foreign_key: :customer_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :from_country_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :to_country_id

  has_many :customer_order_events

  #
  # MIGRATION process: to import customer orders from a legacy system via Excel
  # @param file (string): name of the file containing all the data
  #
  # @return (Hash): message with the result of the import process
  #           i.e.: {
  #                   message: "Records read: 3346 / Records saved: 3178 / Check log file",
  #                   logFile: "./public/downloads/logs/migration_custorder_20180929_1101.log"
  #                 }
  #
  # This process writes a LOG file in /public/downloads/logs directory
  #
  def self.import(file)
     
     # Define variables
     recs_saved = 0
      
    if file.blank? then
      raise 'TRK-0001(E): the FILENAME cannot be empty'
    else
      # Open Excel file and set the headers
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      # Open de LOG file
      logFileName = 'migration_customerorders_' + Time.now().strftime('%Y%m%d_%H%M') + '.log'
      csv_record = File.open(Rails.root.to_s + ApplicationController.helpers.staticPath('log') + logFileName, "w")
       
      # Iterate over each ROW and insert the data into CustomerOrder record
      (2..spreadsheet.last_row).each do |i|
        puts '*** REGISTRO: ' + i.to_s
        row = Hash[[header, spreadsheet.row(i)].transpose]
        puts "OLD NO: //#{row['old_order_no']}//"
        custorder = find_by_old_order_no((row['old_order_no'] || '')) || new
        custorder.attributes = row.to_hash.slice(*custorder.attributes.keys)

        #
        # Validate and fullfill the data
        #
        has_errors = false
        # Field company_id
        if not row['customer_name'].blank? then
          begin
            rec_entity = Entity.find_by(name: row['customer_name'])
            if rec_entity.blank? then
              csv_record.puts("Row: #{i.to_s} - Customer Name not found: #{row['customer_name']}")
              has_errors = true
            else
              custorder.customer_id = rec_entity.id
              custorder.company_id  = rec_entity.company_id
            end
          rescue => e
            csv_record.puts("Row: #{i.to_s} - Error finding customer in Entity table / #{e.to_s}")
            has_errors = true
          end
        else
          csv_record.puts("Row: #{i.to_s} - Customer Name can not be empty.")
          has_errors = true
        end

        # Field order_no
        if custorder.order_no.blank? then
          if not custorder.company_id.blank? then
            rec_aux = CustomerOrder.order(order_no: :desc).find_by company_id: custorder.company_id
            if rec_aux.blank? then
              custorder.order_no = 1
            else
              custorder.order_no = rec_aux.order_no + 1
            end
            puts "ORDER NO:", custorder.order_no
          end
        end

        # Field order_date
        begin
          custorder.order_date = Date.strptime(row['orderDate'], '%m/%d/%Y')
        rescue
          csv_record.puts("Row: #{i.to_s} - order_date conversion error (mm/dd/yyyy): #{row['orderDate']}\n")
          has_errors = true
        end

        # Field observations
        custorder.observations = "MIGRATION             #{ Date.today().strftime("%d-%b-%Y") }\n" \
                               + "OLD Status:           #{ row["observations_status"] }\n" \
                               + "OLD Type:             #{ row["observations_type"] }\n" \
                               + "OLD LastEvent:        #{ row["observations_lastEvent"] }\n" \
                               + "OLD LastInternalNote: #{ row["observations_lastInternal_note"] }\n" 

        # Customer reference
        custorder.cust_ref = row['custRef']

        # Order Status
        custorder.order_status = (row['orderStatus'].blank?)? 'P' : row['orderStatus']

        # OLD order NO. from legacy system
        custorder.old_order_no = row['oldOrderNo']

        # Shipment method
        custorder.shipment_method = (row['shipmentMethod'].blank?)? 'A' : row['shipmentMethod']

        # Delivery Date
        custorder.delivery_date = (row['deliveryDate'].blank?)? nil : Date.strptime(row['deliveryDate'], '%m/%d/%Y')

        # Fields FROM_*
        custorder.from_entity     = row['fromEntity'].rstrip
        custorder.from_address1   = row['fromAddress']
        custorder.from_city       = row['fromCity']
        custorder.from_zipcode    = row['fromZipCode']
        custorder.from_state      = row['fromState']
        custorder.from_country_id = (row['fromCountry_id'].blank?)? 'NNN' : row['fromCountry_id'].rstrip
        custorder.from_contact    = row['fromContact_firstName'] +' '+ row['fromContact_lastName']
        custorder.from_email      = row['fromEmail']
        custorder.from_tel        = row['fromTel']

        # Fields TO_*
        custorder.to_entity      = row['toEntity'].rstrip
        custorder.to_address1    = row['toAddress']
        custorder.to_city        = row['toCity']
        custorder.to_zipcode     = row['toZipCode']
        custorder.to_state       = row['toState']
        custorder.to_country_id  = (row['toCountry_id'].blank?)? 'NNN' : row['toCountry_id'].rstrip
        custorder.to_contact     = row['toContact_firstName'] +' '+ row['toContact_lastName']
        custorder.to_email       = row['toEmail']
        custorder.to_tel         = row['toTel']

        # Third Party Id
        custorder.third_party_id = custorder.customer_id
        
        # Save data
        if not has_errors then
          begin
            custorder.save!
            recs_saved += 1
          rescue => e
            csv_record.puts("Row: #{i.to_s} - error saving to DBase: #{e.to_s}")
          end
        end
      end #loop
      recs_read = spreadsheet.last_row - 1

      csv_record.puts("Records read: #{recs_read.to_s} / Records saved to DBase: #{recs_saved.to_s}")
      csv_record.close()

      if (recs_read == recs_saved) then
        output = {
          "message": "Records read: #{recs_read.to_s} / Records saved to DBase: #{recs_saved.to_s}",
          "logFile": ""
        }
      else
        output = {
          "message": "Records read: #{recs_read.to_s} / Records saved to DBase: #{recs_saved.to_s} / Please, download and check the LOG for errors",
          "logFile": logFileName
        }
      end

      return output

    end

  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
