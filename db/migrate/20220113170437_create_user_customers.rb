class CreateUserCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_customers do |t|
      t.bigint :customer_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
