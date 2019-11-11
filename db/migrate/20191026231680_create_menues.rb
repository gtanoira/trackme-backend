class CreateMenues < ActiveRecord::Migration[5.2]
  def change
    create_table :menues do |t|
      t.string :pgm_id, null: false, index: true, unique: true, comment: 'Id assign to the program'
      t.string :title, comment: 'Program Title'
      t.string :alias, limit: 4, comment: 'Alias for the program (4 digits max) to be printed on the menu button'
      t.string :pgm_group, null: :false, default: 'No group', comment: 'Group ID where the program belongs to'
      t.string :color, null: :false, default: 'black', comment: 'Color for the background button menu'

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
