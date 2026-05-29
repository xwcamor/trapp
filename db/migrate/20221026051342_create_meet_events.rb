class CreateMeetEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :meet_events do |t|
      t.integer :transformer_id
      t.string :title
      t.datetime :start
      t.datetime :end
      t.string :color
      t.integer :deleted

      t.timestamps
    end
  end
end
