class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.bigint  :country_id   
      t.string  :name
      t.string  :num_doc
      t.string  :address
      t.integer :deleted

      t.timestamps
    end
  end
end
