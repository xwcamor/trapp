class CreateIeeeDiags < ActiveRecord::Migration[7.0]
  def change
    create_table :ieee_diags do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.integer :state   
      t.integer :deleted      
      t.integer :month_period    
      t.integer :ppm_hid
      t.integer :ppm_met
      t.integer :ppm_mon
      t.integer :ppm_dio
      t.integer :ppm_eti
      t.integer :ppm_eta
      t.integer :ppm_ace
      t.decimal :ratio

      t.timestamps
    end
  end
end
