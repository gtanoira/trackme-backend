class CreateEventTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_types do |t|
      t.string   :name, null: false
      t.bigint   :tracking_milestone_id
      t.string   :tracking_milestone_css_color, comment: 'This color if present, will override the actual color of the tracking line milestone'

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :event_types, :tracking_milestones, column: :tracking_milestone_id

  end
end
