class CreateChromatographicalDuvals < ActiveRecord::Migration[7.0]
  def change
    create_table :chromatographical_duvals do |t|
      t.bigint  :transformer_id
      t.string  :triangle_diag_first 
      t.string  :triangle_diag_second
      t.string  :triangle_diag_third
      t.string  :pentagon_diag_first 
      t.string  :pentagon_diag_second
      t.string  :pentagon_diag_third      
      t.timestamps
    end
  end
end
