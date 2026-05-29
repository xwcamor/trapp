class CreateDuvals < ActiveRecord::Migration[7.0]
  def change
    create_table :duvals do |t|
      t.integer  :duval_type_id
      t.integer  :graph_type
      t.string   :name
      t.string   :short_name

      t.timestamps
    end
  end
end
