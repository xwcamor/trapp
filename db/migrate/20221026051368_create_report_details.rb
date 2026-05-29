class CreateReportDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :report_details do |t|
      t.bigint   :report_id
      t.bigint   :transformer_id

      t.timestamps
    end
  end
end
