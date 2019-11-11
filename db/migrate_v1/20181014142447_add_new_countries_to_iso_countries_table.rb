class AddNewCountriesToIsoCountriesTable < ActiveRecord::Migration[5.2]
  def change

    # populate the table
    execute(
      "insert into iso_countries
          (id, iso2, name)
        values
          ('BES', 'BQ', 'BONAIRE, SINT EUSTATIUS AND SABA'),
          ('CUW', 'CW', 'CURACAO')
      ")
  end
end
