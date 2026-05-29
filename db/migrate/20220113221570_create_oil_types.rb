class CreateOilTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :oil_types do |t|
      t.string  :name
      t.integer :deleted
      
      t.timestamps
    end
  end
end
