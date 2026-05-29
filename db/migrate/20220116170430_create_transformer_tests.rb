class CreateTransformerTests< ActiveRecord::Migration[5.2]
  def change
    create_table :transformer_tests do |t|
      t.string :name
      t.integer :deleted

      t.timestamps
    end
  end
end
