 class CreateBornals < ActiveRecord::Migration[5.2]
  def change
    create_table :bornals do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.decimal :num_bor
      t.integer :deleted

      t.timestamps
    end
  end
end
