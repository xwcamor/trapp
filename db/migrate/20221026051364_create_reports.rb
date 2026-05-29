class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.bigint   :customer_id
      t.bigint   :user_id
      t.string   :description
      t.integer  :deleted

      t.timestamps
    end
  end
end
