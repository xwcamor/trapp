class CreateDevanadoFlows < ActiveRecord::Migration[5.2]
  def change
    create_table :devanado_flows do |t|
      t.string   :name

      t.timestamps
    end
  end
end
