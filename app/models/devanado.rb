class Devanado < ApplicationRecord
  # Model relationships
  #belongs_to :devanado_template
  belongs_to :transformer
  has_many :devanado_details
  accepts_nested_attributes_for :devanado_details, :allow_destroy => true 
  # Actions using private
  before_save   :save_default_values, :if => :new_record?
  after_create  :update_date_rehearsal
  after_update  :update_date_rehearsal
  after_create  :create_view_devanado_by_transformer_id 
 
  # Audit
  audited associated_with: :transformer
  has_associated_audits
  
  # Validate
  validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
  # Method string on action show
  def str_date_rehearsal
    self.date_rehearsal.strftime("%d-%m-%Y")
  end
  
  private
    def save_default_values
      self.deleted = 0    
    end 

    def update_date_rehearsal
      @transformer = self.transformer_id 
      @devanado= Devanado.find_by_id(self.id)
      @job_update = DevanadoDetail.where("devanado_id = ?",@devanado.id).update_all(date_devanado: @devanado.date_rehearsal)
    end      

    def create_view_devanado_by_transformer_id
      @devanado =Devanado.where("transformer_id = ?",self.transformer_id)
      if  @devanado.size == 1
      devanado_flow_id_1  = ActiveRecord::Base.connection.execute("CREATE view view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id} AS 
        WITH cte AS ( SELECT devanados.transformer_id, a.devanado_id, a.date_devanado, a.col1_val,a.col2_val,a.col3_val, ROW_NUMBER() OVER (PARTITION BY a.date_devanado ORDER BY a.date_devanado DESC, a.id ASC) AS rn
          FROM devanado_details a INNER JOIN devanados ON devanados.id = a.devanado_id
          WHERE devanado_flow_id = 1 AND devanados.transformer_id = #{self.transformer_id} 
        ) SELECT c.transformer_id, c.devanado_id, c.date_devanado AS 'date_devanado', MAX(c.diff1) as 'dif_at_1', ROUND(MAX(c.diffPercent1),4) as 'per_at_1', CONCAT(MAX(c.diff1), ' (', ROUND(MAX(c.diffPercent1),4), '%)') as 'dif_per_at_1',
          MAX(c.diff2) as 'dif_at_2', ROUND(MAX(c.diffPercent2),4) as 'per_at_2', CONCAT(MAX(c.diff2), ' (', ROUND(MAX(c.diffPercent2),4), '%)') as 'dif_per_at_2', MAX(c.diff3) as 'dif_at_3', ROUND(MAX(c.diffPercent3),4) as 'per_at_3', CONCAT(MAX(c.diff3), ' (', ROUND(MAX(c.diffPercent3),4), '%)') as 'dif_per_at_3'    
          FROM ( SELECT b.transformer_id, b.devanado_id, b.date_devanado, b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val) AS diff1, (((b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val))/b.col1_val)*100) AS diffPercent1, b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val) AS diff2, (((b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val))/b.col2_val)*100) AS diffPercent2, b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val) AS diff3, (((b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val))/b.col3_val)*100) AS diffPercent3  FROM cte b
        INNER JOIN devanados ON devanados.id = b.devanado_id ) c GROUP BY c.date_devanado,c.devanado_id
        ORDER BY c.date_devanado  DESC")
      
      devanado_flow_id_2  = ActiveRecord::Base.connection.execute("CREATE view view_devanado_details_by_devanado_flow_id_2_transformer_id_#{self.transformer_id} AS 
        WITH cte AS ( SELECT devanados.transformer_id, a.devanado_id, a.date_devanado, a.col1_val,a.col2_val,a.col3_val, ROW_NUMBER() OVER (PARTITION BY a.date_devanado ORDER BY a.date_devanado DESC, a.id ASC) AS rn
          FROM devanado_details a INNER JOIN devanados ON devanados.id = a.devanado_id
          WHERE devanado_flow_id = 2 AND devanados.transformer_id = #{self.transformer_id} 
        ) SELECT c.transformer_id, c.devanado_id, c.date_devanado AS 'date_devanado', MAX(c.diff1) as 'dif_bt1_1', ROUND(MAX(c.diffPercent1),4) as 'per_bt1_1', CONCAT(MAX(c.diff1), ' (', ROUND(MAX(c.diffPercent1),4), '%)') as 'dif_per_bt1_1',
          MAX(c.diff2) as 'dif_bt1_2', ROUND(MAX(c.diffPercent2),4) as 'per_bt1_2', CONCAT(MAX(c.diff2), ' (', ROUND(MAX(c.diffPercent2),4), '%)') as 'dif_per_bt1_2', MAX(c.diff3) as 'dif_bt1_3', ROUND(MAX(c.diffPercent3),4) as 'per_bt1_3', CONCAT(MAX(c.diff3), ' (', ROUND(MAX(c.diffPercent3),4), '%)') as 'dif_per_bt1_3'    
          FROM ( SELECT b.transformer_id, b.devanado_id, b.date_devanado, b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val) AS diff1, (((b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val))/b.col1_val)*100) AS diffPercent1, b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val) AS diff2, (((b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val))/b.col2_val)*100) AS diffPercent2, b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val) AS diff3, (((b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val))/b.col3_val)*100) AS diffPercent3  FROM cte b
        INNER JOIN devanados ON devanados.id = b.devanado_id ) c GROUP BY c.date_devanado,c.devanado_id
        ORDER BY c.date_devanado  DESC")

      devanado_flow_id_3  = ActiveRecord::Base.connection.execute("CREATE view view_devanado_details_by_devanado_flow_id_3_transformer_id_#{self.transformer_id} AS 
        WITH cte AS ( SELECT devanados.transformer_id, a.devanado_id, a.date_devanado, a.col1_val,a.col2_val,a.col3_val, ROW_NUMBER() OVER (PARTITION BY a.date_devanado ORDER BY a.date_devanado DESC, a.id ASC) AS rn
          FROM devanado_details a INNER JOIN devanados ON devanados.id = a.devanado_id
          WHERE devanado_flow_id = 3 AND devanados.transformer_id = #{self.transformer_id} 
        ) SELECT c.transformer_id, c.devanado_id, c.date_devanado AS 'date_devanado', MAX(c.diff1) as 'dif_bt2_1', ROUND(MAX(c.diffPercent1),4) as 'per_bt2_1', CONCAT(MAX(c.diff1), ' (', ROUND(MAX(c.diffPercent1),4), '%)') as 'dif_per_bt2_1',
          MAX(c.diff2) as 'dif_bt2_2', ROUND(MAX(c.diffPercent2),4) as 'per_bt2_2', CONCAT(MAX(c.diff2), ' (', ROUND(MAX(c.diffPercent2),4), '%)') as 'dif_per_bt2_2', MAX(c.diff3) as 'dif_bt2_3', ROUND(MAX(c.diffPercent3),4) as 'per_bt2_3', CONCAT(MAX(c.diff3), ' (', ROUND(MAX(c.diffPercent3),4), '%)') as 'dif_per_bt2_3'    
          FROM ( SELECT b.transformer_id, b.devanado_id, b.date_devanado, b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val) AS diff1, (((b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val))/b.col1_val)*100) AS diffPercent1, b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val) AS diff2, (((b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val))/b.col2_val)*100) AS diffPercent2, b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val) AS diff3, (((b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val))/b.col3_val)*100) AS diffPercent3  FROM cte b
        INNER JOIN devanados ON devanados.id = b.devanado_id ) c GROUP BY c.date_devanado,c.devanado_id
        ORDER BY c.date_devanado  DESC")

      devanado_flow_id_4  = ActiveRecord::Base.connection.execute("CREATE view view_devanado_details_by_devanado_flow_id_4_transformer_id_#{self.transformer_id} AS
        WITH cte AS ( SELECT devanados.transformer_id, a.devanado_id, a.date_devanado, a.col1_val,a.col2_val,a.col3_val, ROW_NUMBER() OVER (PARTITION BY a.date_devanado ORDER BY a.date_devanado DESC, a.id ASC) AS rn
          FROM devanado_details a INNER JOIN devanados ON devanados.id = a.devanado_id
          WHERE devanado_flow_id = 4 AND devanados.transformer_id = #{self.transformer_id} 
        ) SELECT c.transformer_id, c.devanado_id, c.date_devanado AS 'date_devanado', MAX(c.diff1) as 'dif_bt3_1', ROUND(MAX(c.diffPercent1),4) as 'per_bt3_1', CONCAT(MAX(c.diff1), ' (', ROUND(MAX(c.diffPercent1),4), '%)') as 'dif_per_bt3_1',
          MAX(c.diff2) as 'dif_bt3_2', ROUND(MAX(c.diffPercent2),4) as 'per_bt3_2', CONCAT(MAX(c.diff2), ' (', ROUND(MAX(c.diffPercent2),4), '%)') as 'dif_per_bt3_2', MAX(c.diff3) as 'dif_bt3_3', ROUND(MAX(c.diffPercent3),4) as 'per_bt3_3', CONCAT(MAX(c.diff3), ' (', ROUND(MAX(c.diffPercent3),4), '%)') as 'dif_per_bt3_3'    
          FROM ( SELECT b.transformer_id, b.devanado_id, b.date_devanado, b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val) AS diff1, (((b.col1_val - COALESCE(LEAD(b.col1_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col1_val))/b.col1_val)*100) AS diffPercent1, b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val) AS diff2, (((b.col2_val - COALESCE(LEAD(b.col2_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col2_val))/b.col2_val)*100) AS diffPercent2, b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val) AS diff3, (((b.col3_val - COALESCE(LEAD(b.col3_val) OVER (PARTITION BY b.rn ORDER BY b.date_devanado DESC ), b.col3_val))/b.col3_val)*100) AS diffPercent3  FROM cte b
        INNER JOIN devanados ON devanados.id = b.devanado_id ) c GROUP BY c.date_devanado,c.devanado_id
        ORDER BY c.date_devanado  DESC")
      
      view_by_transformer = ActiveRecord::Base.connection.execute("CREATE view view_devanado_details_by_transformer_id_#{self.transformer_id} AS
       SELECT  
        view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.transformer_id,
        view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.devanado_id,
        view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.date_devanado,
        dif_at_1, per_at_1 , dif_at_2,  per_at_2,  dif_at_3,  per_at_3,
        dif_bt1_1,per_bt1_1, dif_bt1_2, per_bt1_2, dif_bt1_3, per_bt1_3,
        dif_bt2_1,per_bt2_1, dif_bt2_2, per_bt2_2, dif_bt2_3, per_bt2_3,
        dif_bt3_1,per_bt3_1, dif_bt3_2, per_bt3_2, dif_bt3_3, per_bt3_3
        FROM  view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}
        INNER JOIN view_devanado_details_by_devanado_flow_id_2_transformer_id_#{self.transformer_id} ON view_devanado_details_by_devanado_flow_id_2_transformer_id_#{self.transformer_id}.date_devanado = view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.date_devanado
        INNER JOIN view_devanado_details_by_devanado_flow_id_3_transformer_id_#{self.transformer_id} ON view_devanado_details_by_devanado_flow_id_3_transformer_id_#{self.transformer_id}.date_devanado = view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.date_devanado
        INNER JOIN view_devanado_details_by_devanado_flow_id_4_transformer_id_#{self.transformer_id} ON view_devanado_details_by_devanado_flow_id_4_transformer_id_#{self.transformer_id}.date_devanado = view_devanado_details_by_devanado_flow_id_1_transformer_id_#{self.transformer_id}.date_devanado")
 
     else
 

      end 
    end

end 