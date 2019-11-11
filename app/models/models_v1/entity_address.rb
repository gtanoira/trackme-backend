class EntityAddress < ApplicationRecord
  # Polyphormic Referential Integrity
  has_many :endpoints, as: :pointable

  # MIGRATION process: import addresses from a Excel file
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      address = EntityAddress.find_by_entity(row['entity']) || new
      address.attributes = row.to_hash.slice(*address.attributes.keys)
      if address.attributes['country_id'] then
        if address.country_id.strip.blank? then
          address.country_id = 'NNN'
        end
      else
        address.country_id = 'NNN'
      end
      puts "*** ADDRESS BEFORE SAVE:"
      puts address.to_json
      address.save!
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
