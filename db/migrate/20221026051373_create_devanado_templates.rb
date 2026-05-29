class CreateDevanadoTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :devanado_templates do |t|
      t.string  :name
      t.string  :description
      t.string  :unit_name
      t.bigint  :user_id
      t.integer :deleted

      t.timestamps
    end
  end
end
