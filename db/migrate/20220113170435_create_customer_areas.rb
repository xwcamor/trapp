class CreateCustomerAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_areas do |t|
      t.string  :name
      t.bigint  :customer_location_id
      t.bigint  :customer_id
      t.integer :deleted

      t.timestamps
    end
  end
end
