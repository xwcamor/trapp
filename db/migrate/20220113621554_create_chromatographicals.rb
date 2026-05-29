class CreateChromatographicals < ActiveRecord::Migration[5.2]
  def change
    create_table :chromatographicals do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.decimal :num_hid
      t.decimal :num_oxi
      t.decimal :num_nit
      t.decimal :num_met
      t.decimal :num_mon
      t.decimal :num_dio
      t.decimal :num_eti
      t.decimal :num_eta
      t.decimal :num_ace
      t.integer :diag_status      
      t.decimal :deleted

      t.timestamps
    end
  end
end
