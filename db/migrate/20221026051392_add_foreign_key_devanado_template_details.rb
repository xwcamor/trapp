class AddForeignKeyDevanadoTemplateDetails < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :devanado_template_details, :devanado_templates
	  add_foreign_key :devanado_template_details, :devanado_flows
	end
end
