class CreateHoldings < ActiveRecord::Migration[5.1]
  def change
     create_table :holdings do |t|
        t.string :name

        t.timestamps  default: -> {'CURRENT_TIMESTAMP'}
     end
  end
end
