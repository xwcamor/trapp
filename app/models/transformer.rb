class Transformer < ApplicationRecord
  # Model relationships
  belongs_to :transformer_type
  belongs_to :mark
  belongs_to :connection_type
  belongs_to :conmutation_type
  belongs_to :oil_type
  belongs_to :customer_substation
  belongs_to :transformer_preservation
 
  has_many :chromatographicals
  has_many :physicals
  has_many :furanos
  has_many :factors  
  has_many :ieee_diags    
  has_many :gas_keys 
  has_many :report_details
  has_many :devanados

  mount_uploader :duval_triangle_first_image, CustomerUploader
  mount_uploader :duval_pentagon_first_image, CustomerUploader
  
  audited
  has_associated_audits
   
  accepts_nested_attributes_for :chromatographicals, :allow_destroy => true
  accepts_nested_attributes_for :physicals, :allow_destroy => true
  accepts_nested_attributes_for :furanos, :allow_destroy => true  
  accepts_nested_attributes_for :factors, :allow_destroy => true  

  # Actions using private
  before_save :save_default_values, :if => :new_record?
  after_create :create_duval_results

  # Validate
  #validates_uniqueness_of :num_serie, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El nª serie se encuentra en uso."
  validates_uniqueness_of :num_tag, :scope => [:num_serie], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El nª tag se encuentra en uso."


  # Method string on action show
  def str_ratio
    @cr_last = Chromatographical.where("deleted=0 AND transformer_id = ?",self.id).order("date_rehearsal ASC").last
    if @cr_last.nil?
      return    "Sin Cromatografía"
    else
      @ratio_oxi = @cr_last.num_oxi
      @ratio_nit = @cr_last.num_nit
      @ratio_pre =  @ratio_oxi / @ratio_nit 
       return  @ratio_pre.round(2)  
    end
  end


 
  # Method string on action show
  def str_edad
    Time.zone.now.year - self.age
  end

  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y")
  end

  # Method string on action show
  def str_num_fas
    return "Monofásico" if num_fas == 1
    return "Trifásico" if num_fas == 3
  end

  #######################################################  
  # HI CALCULATION
  #######################################################
  def hi_calculation_fin
    @last_chromatographical = Chromatographical.where(transformer_id: self.id, deleted: 0).order('date_rehearsal DESC').first
    @last_physical = Physical.where(transformer_id: self.id, deleted: 0).order('date_rehearsal DESC').first
    @last_furano = Furano.where(transformer_id: self.id, deleted: 0).order('date_rehearsal DESC').first
    #@last_factor = Factor.where(transformer_id: self.id, deleted: 0).order('date_rehearsal DESC').first

    
    @hi1 = @last_chromatographical.dgaf_score_ratio rescue "0"
    @hi2 = @last_physical.dgaf_score_ratio rescue "0"
    @hi3 = @last_furano.dgaf_score_ratio rescue "0"
    #@hi4 = @last_factor.dgaf_score #aun no añade pruebas electricas
    
    @pf1 = 10 #peso Analisis cromatografico
    @pf2 = 6  #peso Analisis FQ
    @pf3 = 5  #peso Analisis FUrano
    #@pf4 = 5  #peso Factor de Potencia

    
    @hi_num_cro = (10*@hi1.to_i)                        
    @hi_num_phy = (6*@hi2.to_i)     
    @hi_num_fur = (5*@hi3.to_i)                            
                      
    @hi_den_cro = (4*@pf1)        
    @hi_den_phy = (4*@pf2)                           
    @hi_den_fur = (4*@pf3)                           

  
    
    @hi_num = @hi_num_cro + @hi_num_phy + @hi_num_fur 
    @hi_den = @hi_den_cro + @hi_den_phy + @hi_den_fur 

   
    @hi_calculation_fin = (@hi_num.to_f/@hi_den.to_f)*100
    return  @hi_calculation_fin
  end

  #######################################################
  # HI CALCULATION DESCRIPTION
  #######################################################
  
  def hi_calculation_fin_condition
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return "Muy Malo"
    elsif @hicfd > 30 && @hicfd <= 50
      return "Malo"
    elsif @hicfd > 50 && @hicfd <= 70 
      return "Medio"
    elsif @hicfd > 70 && @hicfd <=85
      return "Bueno"
    elsif @hicfd > 85     
      return "Muy Bueno"
    end
  end

  def hi_calculation_fin_condition_count_index
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe+ "Muy Malo"
    elsif @hicfd > 30 && @hicfd <= 50
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe+ "Malo"
    elsif @hicfd > 50 && @hicfd <= 70 
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe+ "Medio"
    elsif @hicfd > 70 && @hicfd <=85
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe+ "Bueno"
    elsif @hicfd > 85     
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe+ "Muy Bueno"
    end
  end


  def str_state_health_graph
    @hicfd = self.num_health
    if @hicfd <= 30
      return "Muy Malo"
    elsif @hicfd > 30 && @hicfd <= 50
      return "Malo"
    elsif @hicfd > 50 && @hicfd <= 70 
      return "Medio"
    elsif @hicfd > 70 && @hicfd <=85
      return "Bueno"
    elsif @hicfd > 85     
      return "Muy Bueno"
    end
  end

  def hi_calculation_db
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return 1
    elsif @hicfd > 30 && @hicfd <= 50
      return 2
    elsif @hicfd > 50 && @hicfd <= 70 
      return 3
    elsif @hicfd > 70 && @hicfd <=85
      return 4
    elsif @hicfd > 85     
      return 5
    end
  end

  def hi_calculation_fin_description
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return "Algún envejecimiento o deterioro leve en un número limitado de componentes"
    elsif @hicfd > 30 && @hicfd <= 50
      return "Deterioro significativo de algunos componentes"
    elsif @hicfd > 50 && @hicfd <= 70 
      return "Deterioro significativo en un amplio número de componentes o .deterioro serio en componentes especificos"
    elsif @hicfd > 70 && @hicfd <=85
      return "Deterioro serio en un amplio número de componentes"
    elsif @hicfd > 85     
      return "Deterioro serio generalizado"
    end
  end


  def hi_calculation_fin_description_life
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return "Mayor a 15 años"
    elsif @hicfd > 30 && @hicfd <= 50
      return "Mayor a 10 años"
    elsif @hicfd > 50 && @hicfd <= 70 
      return "Hasta los 10 años"
    elsif @hicfd > 70 && @hicfd <=85
      return "Hasta los 5 años"
    elsif @hicfd > 85     
      return "Final de vida útil"
    end
  end    

  def hi_calculation_fin_color
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe
    elsif @hicfd > 30 && @hicfd <= 50
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe
    elsif @hicfd > 50 && @hicfd <= 70 
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe
    elsif @hicfd > 70 && @hicfd <=85
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe
    elsif @hicfd > 85     
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe
    end
  end    

  def hi_calculation_fin_color_view_show
    @hicfd = self.hi_calculation_fin
    if @hicfd <= 30
      return 'red'.html_safe
    elsif @hicfd > 30 && @hicfd <= 50
      return 'red'.html_safe
    elsif @hicfd > 50 && @hicfd <= 70 
      return 'yellow'.html_safe
    elsif @hicfd > 70 && @hicfd <=85
      return 'green'.html_safe
    elsif @hicfd > 85     
      return 'green'.html_safe
    end
  end    

  # Method string on action show
  def str_color_health
    return "success"      if self.color_health == "green"
    return "warning"      if self.color_health == "yellow"
    return "danger"       if self.color_health == "red"
  end
  
  ##########################
  ###### BEGIN  JSON ARRAY #
  ##########################
  def info_country_name
    self.customer_substation.customer_area.customer_location.customer.country.name.to_s rescue "-"
  end

  def info_mark
    self.mark.name.upcase.to_s  rescue "-"
  end

  def info_num_status
    self.hi_calculation_fin.round(0)  rescue "0"
  end  

  def info_calc_status
    self.hi_calculation_fin_condition rescue "Muy Malo"
  end 

  def info_type_transformer
    self.transformer_type.name.upcase rescue "-"
  end 

  def info_conmutation_type
    self.conmutation_type.name.upcase rescue "-"
  end     
 

 
  ##########################
  ###### END  JSON ARRAY #
  ##########################
 

  # Pagination = 10
  self.per_page = 10

  private
    def save_default_values
      self.deleted = 0    
    end 

    def create_duval_results
      @chromatographical_duval = ChromatographicalDuval.create(transformer_id: self.id )
      @chromatographical_dga_diag = ChromatographicalDgaDiag.create(transformer_id: self.id )
    end 
 
end 