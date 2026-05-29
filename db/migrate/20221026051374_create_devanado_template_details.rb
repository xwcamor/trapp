class CreateDevanadoTemplateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :devanado_template_details do |t|
      t.bigint  :devanado_template_id
      t.bigint  :devanado_flow_id
      t.string  :name

      t.timestamps
    end
  end
end
