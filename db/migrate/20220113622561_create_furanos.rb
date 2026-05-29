 class CreateFuranos < ActiveRecord::Migration[5.2]
  def change
    create_table :furanos do |t|
      t.bigint  :transformer_id
      t.date    :date_rehearsal
      t.decimal :num_fal
      t.decimal :num_hme
      t.decimal :num_ace
      t.decimal :num_mfu
      t.decimal :num_fua
      t.integer :deleted

      t.timestamps
    end
  end
end
