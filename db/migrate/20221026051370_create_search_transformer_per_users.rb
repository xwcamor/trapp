class CreateSearchTransformerPerUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :search_transformer_per_users do |t|
      t.bigint   :user_id
      t.bigint   :customer_id
      t.string   :transformer_id

      t.timestamps
    end
  end
end
