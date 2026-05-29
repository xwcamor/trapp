class AddForeignKeyDevanadoTemplateTransformers < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :devanado_template_transformers, :transformers
	  add_foreign_key :devanado_template_transformers, :devanado_templates
	end
end
