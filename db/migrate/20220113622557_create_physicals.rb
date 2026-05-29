 class CreatePhysicals < ActiveRecord::Migration[5.2]
  def change
    create_table :physicals do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.decimal :num_acid
      t.decimal :num_pot
      t.decimal :num_pot2
      t.decimal :num_rig
      t.decimal :num_rig2
      t.decimal :num_ten
      t.decimal :num_wat
      t.integer :diag_status
      t.integer :deleted

      t.timestamps
    end
  end
end
