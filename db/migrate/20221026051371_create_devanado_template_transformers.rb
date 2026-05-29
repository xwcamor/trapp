class CreateDevanadoTemplateTransformers < ActiveRecord::Migration[5.2]
  def change
    create_table :devanado_template_transformers do |t|
      t.bigint  :transformer_id
      t.bigint  :devanado_template_id

      t.timestamps
    end
  end
end
