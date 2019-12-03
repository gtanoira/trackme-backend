class Event < ApplicationRecord
  # Foreign keys
  belongs_to :account
  belongs_to :tracking_milestone
  has_many :order_events
  
  # **************************************************************************************************
  # MIGRATION process: to import Events definitions from a legacy system via Excel
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
      logFileName = 'migration_events_' + Time.now().strftime('%Y%m%d_%H%M') + '.log'
      csv_record = File.open(Rails.root.to_s + ApplicationController.helpers.staticPath('log') + logFileName, "w")
      
      # Iterate over each ROW and insert the data into CustomerOrder record
      (2..spreadsheet.last_row).each do |i|
        puts '*** RECORD: ' + i.to_s
        row = Hash[[header, spreadsheet.row(i)].transpose]
        puts "OLD NO: //#{row['legacy_order_no']}//"
        newRecord = Event.new
        newRecord.attributes = row.to_hash.slice(*newRecord.attributes.keys)

        #
        # Validate and fullfill the data
        #
        has_errors = false
        # Name
        if row['name'].blank? then
          csv_record.puts("Row: #{i.to_s} - Event Name can not be empty.")
          has_errors = true
        end
        
        # Account_id
        if row['account_id'].blank? then
          csv_record.puts("Row: #{i.to_s} - Account_id can not be empty.")
          has_errors = true
        end
       
        # Save data
        if not has_errors then
          begin
            newRecord.save!
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
