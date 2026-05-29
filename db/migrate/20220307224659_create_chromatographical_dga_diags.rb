class CreateChromatographicalDgaDiags < ActiveRecord::Migration[7.0]
  def change
    create_table :chromatographical_dga_diags do |t|
      t.bigint  :transformer_id
      t.string  :eval_first
      t.string  :eval_second
      t.string  :eval_third
      t.string  :eval_fourth
  
      t.timestamps
    end
  end
end
