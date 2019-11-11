class Entity < ApplicationRecord
  # Foreign keys
  belongs_to :country
  
  # Polymorphic associations
  has_many :endpoints, as: :pointable

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      entity = find_by_name(row['name']) || new
      entity.attributes = row.to_hash.slice(*entity.attributes.keys)
      if entity.attributes['country_id'] then
        if entity.country_id.strip.blank? then
           entity.country_id = 'NNN'
        end
      else
        entity.country_id = 'NNN'
      end
      puts "ENTITY BEFORE SAVE:"
      puts entity.to_json
      entity.save!
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
