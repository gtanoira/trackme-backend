class Client < Entity

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      
      # Find client or create a new one
      client = find_by_name(row['name']) || new
      client.attributes = row.to_hash.slice(*client.attributes.keys)
      # Country validation
      if client.attributes['country_id'] then
        if client.country_id.strip.blank? then
           client.country_id = 'NNN'
        end
      else
        client.country_id = 'NNN'
      end
      
      puts "*** CLient BEFORE SAVE:"
      puts client.to_json
      client.save!
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
