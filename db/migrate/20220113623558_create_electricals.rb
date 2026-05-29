 class CreateElectricals < ActiveRecord::Migration[5.2]
  def change
    create_table :electricals do |t|
      t.bigint :transformer_id
      t.date    :date_rehearsal
      t.decimal :val_a1
      t.decimal :va_a2

 
      t.integer :deleted

      t.timestamps
    end
  end
end
