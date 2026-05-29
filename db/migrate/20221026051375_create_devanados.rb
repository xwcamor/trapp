class CreateDevanados < ActiveRecord::Migration[5.2]
  def change
    create_table :devanados do |t|
      t.bigint   :transformer_id
      t.date     :date_rehearsal
      t.integer  :deleted

      t.timestamps
    end
  end
end
