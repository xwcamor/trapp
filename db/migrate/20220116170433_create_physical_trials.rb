class CreatePhysicalTrials< ActiveRecord::Migration[5.2]
  def change
    create_table :physical_trials do |t|
      t.bigint :transformer_test_id
      t.string  :name
      t.string  :short_name
      t.string  :unit_name
      t.integer :deleted

      t.timestamps
    end
  end
end
