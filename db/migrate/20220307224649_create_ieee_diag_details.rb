class CreateIeeeDiagDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :ieee_diag_details do |t|
      t.bigint :chromatographical_id
      t.bigint :ieee_diag_id

      t.timestamps
    end
  end
end
