class Item < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :company
  belongs_to :entity,  class_name: 'Entity', foreign_key: :customer_id
  belongs_to :internal_order

  # ENUM fields declarations (starts with 0 zero)
  enum condition: { 
    original: 'Original',
    used: 'Used',
    failed: 'Failed',
    repaired: 'Repaired'
  }
  enum item_type: {
    box: 'Box',
    deco: 'Deco'
  }
  enum status: {
    onHand: 'OnHand',
    inTransit: 'InTransit',
    delivered: 'Delivered',
    deleted: 'Deleted'
  }
  enum unit_length: { 
    cm: 'cm',
    inch: 'inch'
  }
  enum unit_volume: {
    m3: 'm3',
    kg3: 'kg3'
  }
  enum unit_weight: {
    kg: 'kg',
    pounds: 'pounds'
  }

  # **********************************************************************************************
  # MIGRATION process: to import items from a legacy system via Excel
  # @param file (string): name of the file containing all the data
  #
  # @return (Hash): message with the result of the import process
  #           i.e.: {
  #                   message: "Records read: 3346 / Records saved: 3178 / Check log file",
  #                   logFile: "./public/downloads/logs/migration_itemsr_YYYMMDD_mmss.log"
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
      logFileName = 'migration_items_' + Time.now().strftime('%Y%m%d_%H%M') + '.log'
      csv_record = File.open(Rails.root.to_s + ApplicationController.helpers.staticPath('log') + logFileName, "w")
      
      # Iterate over each ROW and insert the data into CustomerOrder record
      (2..spreadsheet.last_row).each do |i|
        puts '*** REGISTRO: ' + i.to_s
        row = Hash[[header, spreadsheet.row(i)].transpose]
        #custorder = find_by_old_order_no((row['old_order_no'] || '')) || new
        item = Item.new
        item.attributes = row.to_hash.slice(*item.attributes.keys)

        #
        # Validate and fullfill the data
        #
        has_errors = false

        # Field customer_id & company_id
        if not row['customer_name'].blank? then
          begin
            rec_entity = Entity.find_by(name: row['customer_name'])
            if rec_entity.blank? then
              csv_record.puts("Row: #{i.to_s} - Customer Name not found: #{row['customer_name']}")
              has_errors = true
            else
              item.customer_id = rec_entity.id
              item.company_id  = rec_entity.company_id
            end
          rescue => e
            csv_record.puts("Row: #{i.to_s} - Error finding customer in Entity table / #{e.to_s}")
            has_errors = true
          end
        else
          csv_record.puts("Row: #{i.to_s} - Customer Name can not be empty.")
          has_errors = true
        end

        # Field item_id
        if row['item_id'].blank? then
          csv_record.puts("Row: #{i.to_s} - Item ID can not be empty.")
          has_errors = true
        else
          item.item_id = row['item_id']
        end

        # Field internal_order_id
        if row['internal_order_id'].blank? then
          csv_record.puts("Row: #{i.to_s} - Internal order ID can not be empty.")
          has_errors = true
        else
          begin
            rec_internal_order = InternalOrder.find(row['internal_order_id'])
            if rec_internal_order.blank? then
              csv_record.puts("Row: #{i.to_s} - Internal Order not found: #{row['internal_order_id']}")
              has_errors = true
            else
              item.internal_order_id = rec_internal_order.id
            end
          rescue => e
            csv_record.puts("Row: #{i.to_s} - Error finding customer in Entity table / #{e.to_s}")
            has_errors = true
          end

        end

        # Field item_type
        item.item_type = row['item_type']

        # Field status
        if row['status'].blank? then
          csv_record.puts("Row: #{i.to_s} - Status can not be empty.")
          has_errors = true
        else
          item.status = row['status']
        end

        # Field manufacter
        item.manufacter = row['manufacter']

        # Field model
        item.model = row['model']

        # Field part_number
        item.part_number = row['part_number']

        # Field serial_number
        item.serial_number = row['serial_number']

        # Field ua_number
        item.ua_number = row['ua_number']

        # Field condition
        item.condition = row['condition']

        # Field contents
        item.contents = row['contents']
       
        # Save data
        if not has_errors then
          begin
            item.save!
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
