class CreateTrackingMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :tracking_milestones do |t|
      t.string  :name, null: false, comment: "Short description for screen use (alias)"
      t.integer :place_order, comment: "Order of resolution: 1-low n:high"
      t.string  :css_color, default: "coral", comment: "CSS color to use for painting on the screen"
      t.string  :description, comment: "Long description"
      t.string  :language, null: false,  default: "en", comment: "Language used to describe the tracking milestone"
      t.bigint  :account_id, null: false, comment: "Belgons to this account ID"
    end

    # Add foreign keys
    add_foreign_key :tracking_milestones, :accounts

    reversible do |dir|
      dir.up do
        # populate the table
        execute <<-SQL
          insert into tracking_milestones
            (name, place_order, css_color, description, account_id)
            values
              ("Order Processing", 1, "green", "Pre-shipment process. The cargo is not available in stock", 1),
              ("On Hand", 2, "green", "The cargo is in the stock", 1),
              ("Booking On process", 3, "green", "The customer gave permission to send the cargo", 1),
              ("In Transit", 4, "green", "The cargo is in transit", 1),
              ("Custom Clearance", 5, "green", "Custom Clearance", 1),
              ("Delivered", 6, "blue",  "Delivered", 1);
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
