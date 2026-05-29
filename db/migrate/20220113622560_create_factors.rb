 class CreateFactors < ActiveRecord::Migration[5.2]
  def change
    create_table :factors do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.decimal :num_fac
      t.integer :diag_status      
      t.integer :deleted
      
      t.timestamps
    end
  end
end
