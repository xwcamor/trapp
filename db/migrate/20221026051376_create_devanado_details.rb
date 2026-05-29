class CreateDevanadoDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :devanado_details do |t|
      t.bigint   :devanado_id
      t.bigint   :devanado_flow_id
      t.date     :date_devanado
      t.decimal  :col1_val
      t.decimal  :col2_val
      t.decimal  :col3_val

      t.timestamps
    end
  end
end
