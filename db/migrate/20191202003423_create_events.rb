class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string  :name, null: false
      t.string  :scope, null: false, default: 'private', comment: 'Who can see this event: (private)-only the company / (public)-the company and client'
      t.bigint  :tracking_milestone_id
      t.string  :tracking_milestone_css_color, comment: 'This color if present, will override the actual color of the tracking line milestone'
      t.bigint  :account_id, null: false, comment: "Belgons to this account ID"

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :events, :tracking_milestones
    add_foreign_key :events, :accounts

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE events MODIFY `scope` enum('private', 'public') NOT NULL DEFAULT 'private' COMMENT '(enum) Who can see this event: (private)-only the company / (public)-the company and client';
        SQL
      end
      dir.down do
        change_column :events, :scope,   :string, comment: '(enum) Who can see this event: (private)-only the company / (public)-the company and client'
      end
    end

  end
end
