class CreateTrackingMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :tracking_milestones do |t|
      t.string  :name
      t.integer :place_order
      t.string  :css_color
      t.string  :description
    end

    reversible do |dir|
      dir.up do
        # populate the table
        execute <<-SQL
          insert into tracking_milestones
              (name, place_order, css_color, description)
            values
              ('Order Processing',   1, 'green', 'Pre-shipment process. The cargo is not available in stock'),
              ('On Hand',            2, 'green', 'The cargo is in the stock'),
              ('Booking On process', 3, 'green', 'The customer gave permission to send the cargo'),
              ('In Transit',         4, 'green',  'The cargo is in transit'),
              ('Custom Clearance',   5, 'green',  'Custom Clearance'),
              ('Delivered',          6, 'blue',  'Delivered');
        SQL
      end
      dir.down do
        execute <<-SQL
          truncate table tracking_milestones
        SQL
      end
    end
  end

end
