class CreateGasKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :gas_keys do |t|
      t.bigint  :transformer_id
      t.integer  :state

      t.timestamps
    end
  end
end
