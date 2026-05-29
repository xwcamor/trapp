class CreateTransformers < ActiveRecord::Migration[5.2]
  def change
    create_table :transformers do |t|
      t.bigint  :customer_substation_id      
      t.bigint  :transformer_type_id
      t.bigint  :connection_type_id
      t.bigint  :conmutation_type_id
      t.bigint  :transformer_preservation_id
      t.bigint  :oil_type_id
      t.bigint  :mark_id      
      t.string  :num_serie
      t.string  :num_tag
      t.decimal :num_vol
      t.decimal :num_pot
      t.integer :age
      t.integer :num_fas
      t.integer :num_tap
      t.integer :num_health
      t.integer :state_health
      t.integer :deleted
  
      t.timestamps
    end
  end
end
