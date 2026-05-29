class Chromatographical < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  # Model relationships
  belongs_to :transformer
  has_many :ieee_diag_details
  has_many :posts
     
  # Actions using private
  before_save :save_default_values, :if => :new_record?
  before_create :save_default_values_job, :if => :new_record?
  after_update  :update_default_values_job
  after_destroy :update_nested_value


  after_create :update_transformer_report_fields
  after_update :update_transformer_report_fields
  
  # Audit
  audited associated_with: :transformer

  # Validate
  validates_presence_of :date_rehearsal, message: 'No puede estar en blanco o vacío.' 
  validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "La Fecha ya existe."
  validates_presence_of :num_hid, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_oxi, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_nit, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_met, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_mon, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_dio, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_eti, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_eta, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_ace, message: 'No puede estar en blanco o vacío.' 


  def str_date_rehearsal
    date_rehearsal_in_lima = self.date_rehearsal.in_time_zone('America/Lima')
    date_format = self.transformer.has_special_testing_cro == 0 ? "%d-%m-%Y" : "%d-%m-%Y %H:%M:%S"
    date_rehearsal_in_lima.strftime(date_format)
  end

   
  # Method string on action show
  def str_date_rehearsal_old_working
    if self.transformer.has_special_testing_cro == 0
      self.date_rehearsal.strftime("%d-%m-%Y")
    else
      self.date_rehearsal.strftime("%d-%m-%Y %H:%M:%S")
    end
  end

  # Method string on action show
  def str_date_rehearsal_table
    self.date_rehearsal.strftime("%Y%m%d")
  end


  # Method string on action show
  def str_date_rehearsal_day
    self.date_rehearsal.strftime("%A")
  end

  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y")
  end

  def suma_gases_combustibles
    self.num_hid + self.num_met + self.num_mon + self.num_eti + self.num_eta + self.num_ace
  end

  def suma_total_gases
    self.num_hid + self.num_oxi + self.num_nit + self.num_met + self.num_mon + self.num_dio + self.num_eti + self.num_eta + self.num_ace
  end

  def suma_duval
    self.num_met + self.num_eti + self.num_ace
  end

  def metano_duval
    (self.num_met.to_d/self.suma_duval)*100
  end

  def etileno_duval
    (self.num_eti.to_d/self.suma_duval)*100
  end

  def acetileno_duval
    (self.num_ace.to_d/self.suma_duval)*100
  end

  #######################################################
  # DUVAL TRIANGLES STRINGS
   def tr1_sum_values
    @tr1_suma =self.num_met.to_i +  self.num_eti.to_i + self.num_ace.to_i 
    return @tr1_suma
  end

  def tr1_met_percent  ## CH4
    @div1 = self.num_met.to_f/self.tr1_sum_values.to_f*100 
    if @div1 > 0
      @prec1 = number_with_precision(@div1.to_f, :precision => 1 )
      @value1 = @prec1.to_d.round      
    else
      @value1 = 0
    end
    return @value1
  end
  
  def tr1_eti_percent  ## C2H4
    @div2 = self.num_eti.to_f/self.tr1_sum_values.to_f*100 
    if @div2 > 0
      @prec2 = number_with_precision(@div2.to_f, :precision => 1 )
      @value2 = @prec2.to_d.round      
    else
      @value2 = 0
    end   
    return @value2
  end  

  def tr1_ace_percent  ## C2H2
    @div3 = self.num_ace.to_f/self.tr1_sum_values.to_f*100 
    if @div3 > 0
      @prec3 = number_with_precision(@div3.to_f, :precision => 1 )
      @value3 = @prec3.to_d.round      
    else
      @value3 = 0
    end    
    return @value3
  end    

  def tr2_sum_values
    @tr2_suma =self.num_hid.to_i +  self.num_met.to_i + self.num_eta.to_i 
    return @tr2_suma
  end

  def tr2_hid_percent  ## H2
    @div4 = self.num_hid.to_f/self.tr2_sum_values.to_f*100 
    if @div4 > 0
      @prec4 = number_with_precision(@div4.to_f, :precision => 1 )
      @value4 = @prec4.to_d.round      
    else
      @value4 = 0
    end   
    return @value4
  end  

  def tr2_met_percent  ## CH4
    @div5 = self.num_met.to_f/self.tr2_sum_values.to_f*100 
    if @div5 > 0
      @prec5 = number_with_precision(@div5.to_f, :precision => 1 )
      @value5 = @prec5.to_d.round      
    else
      @value5 = 0
    end    
    return @value5
  end

  def tr2_eta_percent  ## C2H6
    @div6 = self.num_eta.to_f/self.tr2_sum_values.to_f*100 
    if @div6 > 0
      @prec6 = number_with_precision(@div6.to_f, :precision => 1 )
      @value6 = @prec6.to_d.round      
    else
      @value6 = 0
    end     
    return @value6
  end      

   def tr3_sum_values
    @tr3_suma =self.num_met.to_i + self.num_eti.to_i + self.num_eta.to_i 
    return @tr3_suma
  end

  def tr3_met_percent  ## CH4
    @div7 = self.num_met.to_f/self.tr3_sum_values.to_f*100 
    if @div7 > 0
      @prec7 = number_with_precision(@div7.to_f, :precision => 1 )
      @value7 = @prec7.to_d.round      
    else
      @value7 = 0
    end       
    return @value7
  end

  def tr3_eti_percent  ## C2H4
    @div8 = self.num_eti.to_f/self.tr3_sum_values.to_f*100 
    if @div8 > 0
      @prec8 = number_with_precision(@div8.to_f, :precision => 1 )
      @value8 = @prec8.to_d.round      
    else
      @value8 = 0
    end         
    return @value8
  end  

  def tr3_eta_percent  ## C2H6
    @div9 = self.num_eta.to_f/self.tr3_sum_values.to_f*100 
    if @div9 > 0
      @prec9 = number_with_precision(@div9.to_f, :precision => 1 )
      @value9 = @prec9.to_d.round      
    else
      @value9 = 0
    end      
    return @value9
  end     
 
 #######################################################
  # DUVAL TRIANGLES STRINGS
  def pn1_sum_values
    @pn1_suma =self.num_hid.to_i +  self.num_met.to_i +  self.num_eti.to_i + self.num_eta.to_i  + self.num_ace.to_i 
    return @pn1_suma
  end

  def pn1_hid_percent  ## CH4
    @div10 = self.num_hid.to_f/self.pn1_sum_values.to_f*100 
    if @div10 > 0
      @prec10 = number_with_precision(@div10.to_f, :precision => 1 )
      @value10 = @prec10.to_d.round      
    else
      @value10 = 0
    end      
    return @value10
  end

  def pn1_met_percent  ## C2H4
    @div11 = self.num_met.to_f/self.pn1_sum_values.to_f*100 
    if @div11 > 0
      @prec11 = number_with_precision(@div11.to_f, :precision => 1 )
      @value11 = @prec11.to_d.round      
    else
      @value11 = 0
    end    
    return @value11
  end  

  def pn1_eti_percent  ## C2H4
    @div12 = self.num_eti.to_f/self.pn1_sum_values.to_f*100 
    if @div12 > 0
      @prec12 = number_with_precision(@div12.to_f, :precision => 1 )
      @value12 = @prec12.to_d.round      
    else
      @value12 = 0
    end        
    return @value12
  end  

  def pn1_eta_percent  ## C2H2
    @div13 = self.num_eta.to_f/self.pn1_sum_values.to_f*100 
    if @div13 > 0
      @prec13 = number_with_precision(@div13.to_f, :precision => 1 )
      @value13 = @prec13.to_d.round      
    else
      @value13 = 0
    end      
    return @value13
  end    

  def pn1_ace_percent  ## C2H2
    @div14 = self.num_ace.to_f/self.pn1_sum_values.to_f*100 
    if @div14 > 0
      @prec14 = number_with_precision(@div14.to_f, :precision => 1 )
      @value14 = @prec14.to_d.round      
    else
      @value14 = 0
    end      
    return @value14
  end    

 
  #######################################################
  # CALCULO DE TIPO TRANSFORMADOR
  #######################################################
  def suma_score_peso
    ########################################
    # CASO DE SCORE PARA ACEITE MINERAL
    ########################################
    if self.transformer.oil_type_id == 1
      if self.transformer.transformer_type_id == 1
         # suma de pesos de tipo potencia
         suma_total_peso_tipo_pot = 18.0 
         suma_score_x_peso_tipo_pot = hidrogeno_score_peso_tipo_pot + metano_score_peso_tipo_pot + etileno_score_peso_tipo_pot + etano_score_peso_tipo_pot + monocarbono_score_peso_tipo_pot + diocarbono_score_peso_tipo_pot + acetileno_score_peso_tipo_pot
         sumatoria_dgaf_tipo_pot =  suma_score_x_peso_tipo_pot/suma_total_peso_tipo_pot
         return sumatoria_dgaf_tipo_pot
      elsif self.transformer.transformer_type_id == 2
         # suma de pesos de tipo distribucion
         suma_total_peso_tipo_dis = 18.0 
         suma_score_x_peso_tipo_dis = hidrogeno_score_peso_tipo_dis + metano_score_peso_tipo_dis + etileno_score_peso_tipo_dis + etano_score_peso_tipo_dis + monocarbono_score_peso_tipo_dis + diocarbono_score_peso_tipo_dis + acetileno_score_peso_tipo_dis
         sumatoria_dgaf_tipo_dis =  suma_score_x_peso_tipo_dis/suma_total_peso_tipo_dis
         return sumatoria_dgaf_tipo_dis
      elsif self.transformer.transformer_type_id == 3
         # suma de pesos de tipo potencia
         suma_total_peso_tipo_hor = 18.0 
         suma_score_x_peso_tipo_hor = hidrogeno_score_peso_tipo_hor + metano_score_peso_tipo_hor + etileno_score_peso_tipo_hor + etano_score_peso_tipo_hor + monocarbono_score_peso_tipo_hor + diocarbono_score_peso_tipo_hor
         sumatoria_dgaf_tipo_hor =  suma_score_x_peso_tipo_hor/suma_total_peso_tipo_hor
         return sumatoria_dgaf_tipo_hor
      end
    ########################################
    # CASO DE SCORE PARA ACEITE SILICONA
    ########################################
    elsif self.transformer.oil_type_id == 4
      suma_total_peso_tipo_silicona = 18.0
      suma_score_x_peso_tipo_silicona = hidrogeno_score_peso_tipo_silicona + metano_score_peso_tipo_silicona + etileno_score_peso_tipo_silicona + etano_score_peso_tipo_silicona + monocarbono_score_peso_tipo_silicona + diocarbono_score_peso_tipo_silicona + acetileno_score_peso_tipo_silicona
      sumatoria_dgaf_tipo_silicona =  suma_score_x_peso_tipo_silicona/suma_total_peso_tipo_silicona
      return sumatoria_dgaf_tipo_silicona

    ########################################
    # CASO DE SCORE PARA ACEITE VEGETAL SOYA
    ########################################
    elsif self.transformer.oil_type_id == 5
      suma_total_peso_tipo_vegetal_soya = 17.0 
      suma_score_x_peso_tipo_vegetal_soya = hidrogeno_score_peso_tipo_vegetal_soya + metano_score_peso_tipo_vegetal_soya + etileno_score_peso_tipo_vegetal_soya + etano_score_peso_tipo_vegetal_soya + monocarbono_score_peso_tipo_vegetal_soya + acetileno_score_peso_tipo_vegetal_soya
      sumatoria_dgaf_tipo_vegetal_soya =  suma_score_x_peso_tipo_vegetal_soya/suma_total_peso_tipo_vegetal_soya
      return sumatoria_dgaf_tipo_vegetal_soya  

    ########################################
    # CASO DE SCORE PARA ACEITE VEGETAL SOYA
    ########################################
    elsif self.transformer.oil_type_id == 6
      suma_total_peso_tipo_vegetal_girasol = 17.0 
      suma_score_x_peso_tipo_vegetal_girasol = hidrogeno_score_peso_tipo_vegetal_girasol + metano_score_peso_tipo_vegetal_girasol + etileno_score_peso_tipo_vegetal_girasol + etano_score_peso_tipo_vegetal_girasol + monocarbono_score_peso_tipo_vegetal_girasol + acetileno_score_peso_tipo_vegetal_girasol
      sumatoria_dgaf_tipo_vegetal_girasol =  suma_score_x_peso_tipo_vegetal_girasol/suma_total_peso_tipo_vegetal_girasol
      return sumatoria_dgaf_tipo_vegetal_girasol           
    end      
  end

  def dgaf_condition
    if suma_score_peso < 1.2
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Muy Bueno".to_s #+ suma_score_peso.to_s 
    elsif suma_score_peso >= 1.2 && suma_score_peso < 1.5
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Bueno".to_s
    elsif suma_score_peso >= 1.5 && suma_score_peso < 2
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe + "Medio".to_s
    elsif suma_score_peso >= 2 && suma_score_peso < 3
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Malo".to_s
    elsif suma_score_peso >= 3
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Muy Malo".to_s
    end
  end

  def dgaf_score
    if suma_score_peso < 1.2
      return 40  
    elsif suma_score_peso >= 1.2 && suma_score_peso < 1.5
      return 30
    elsif suma_score_peso >= 1.5 && suma_score_peso < 2
      return 20
    elsif suma_score_peso >= 2 && suma_score_peso < 3
      return 10
    elsif suma_score_peso >= 3
      return 0
    end
  end

  def dgaf_score_ratio
    if    self.dgaf_score == 40
      return 4
    elsif self.dgaf_score == 30
      return 3
    elsif self.dgaf_score == 20
      return 2
    elsif self.dgaf_score == 10
      return 1
    elsif self.dgaf_score == 0
      return 0
    end
  end

  #######################################################
  #############  STATUS ON SORT LINK ####################
  #######################################################
  def str_diag_status
    if suma_score_peso < 1.2
      return 5 #+ suma_score_peso.to_s 
    elsif suma_score_peso >= 1.2 && suma_score_peso < 1.5
      return 4
    elsif suma_score_peso >= 1.5 && suma_score_peso < 2
      return 3
    elsif suma_score_peso >= 2 && suma_score_peso < 3
      return 2
    elsif suma_score_peso >= 3
      return 1
    end
  end

  def str_diag_status_detail
    if self.diag_status == 5
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Muy Bueno".to_s #+ suma_score_peso.to_s 
    elsif self.diag_status == 4
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Bueno".to_s
    elsif self.diag_status == 3
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe + "Regular".to_s
    elsif self.diag_status == 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Malo".to_s
    elsif self.diag_status == 1
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Muy Malo".to_s
    end
  end
  
  #######################################################
  # CALCULOS DE TRANSFORMADOR DE POTENCIA NORMA IEC
  #######################################################
  def hidrogeno_score_peso_tipo_pot
    if self.num_hid <= 150
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 150 && self.num_hid <= 200 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 200 && self.num_hid <= 300
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 300 && self.num_hid <= 500
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 500 && self.num_hid <= 700
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_pot
    if self.num_met <= 130 
      @scoregas = 1 # Score = 1
    elsif self.num_met > 130 && self.num_met <= 150 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 150 && self.num_met <= 200
      @scoregas = 3 # Score = 3
    elsif self.num_met > 200 && self.num_met <= 400
      @scoregas = 4 # Score = 4
    elsif self.num_met > 400 && self.num_met <= 600
      @scoregas = 5 # Score = 5
    elsif self.num_met > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_pot
    if self.num_eti <= 280
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 280 && self.num_eti <= 350 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 350 && self.num_eti <= 400
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 400 && self.num_eti <= 450
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 450 && self.num_eti <= 500
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 500
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_pot
    if self.num_eta <= 90 
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 90 && self.num_eta <= 110 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 110 && self.num_eta <= 150
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 150 && self.num_eta <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 200 && self.num_eta <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_pot
    if self.num_mon <= 600 
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 600 && self.num_mon <= 700 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 700 && self.num_mon <= 900
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 900 && self.num_mon <= 1100
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 1100 && self.num_mon <= 1400
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 1400
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo_pot
    if self.num_dio <= 14000 
      @scoregas = 1 # Score = 1
    elsif self.num_dio > 14000 && self.num_dio <= 15000
      @scoregas = 2 # Score = 2
    elsif self.num_dio > 15000 && self.num_dio <= 16000
      @scoregas = 3 # Score = 3
    elsif self.num_dio > 16000 && self.num_dio <= 17000
      @scoregas = 4 # Score = 4
    elsif self.num_dio > 17000 && self.num_dio <= 18000
      @scoregas = 5 # Score = 5
    elsif self.num_dio > 18000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo_pot
    if self.num_ace <= 20 
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 20 && self.num_ace <= 30 
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 30 && self.num_ace <= 40
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 40 && self.num_ace <= 50
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 50 && self.num_ace <= 80
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 80
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE DISTRIBUCION NORMA IEC
  #######################################################
  def hidrogeno_score_peso_tipo_dis
    if self.num_hid <= 100
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 100 && self.num_hid <= 200 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 200 && self.num_hid <= 300
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 300 && self.num_hid <= 500
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 500 && self.num_hid <= 700
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_dis
    if self.num_met <= 50
      @scoregas = 1 # Score = 1
    elsif self.num_met > 50 && self.num_met <= 75 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 75 && self.num_met <= 100
      @scoregas = 3 # Score = 3
    elsif self.num_met > 100 && self.num_met <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_met > 200 && self.num_met <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_met > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_dis
    if self.num_eti <= 50
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 50 && self.num_eti <= 75 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 75 && self.num_eti <= 100
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 100 && self.num_eti <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 200 && self.num_eti <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_dis
    if self.num_eta <= 50
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 50 && self.num_eta <= 75
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 75 && self.num_eta <= 100
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 100 && self.num_eta <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 200 && self.num_eta <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_dis
    if self.num_mon <= 200
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 200 && self.num_mon <= 300 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 300 && self.num_mon <= 400
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 400 && self.num_mon <= 500
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 500 && self.num_mon <= 600
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo_dis
    if self.num_dio <= 5000 
      @scoregas = 1 # Score = 1
    elsif self.num_dio > 5000 && self.num_dio <= 6000
      @scoregas = 2 # Score = 2
    elsif self.num_dio > 6000 && self.num_dio <= 7000
      @scoregas = 3 # Score = 3
    elsif self.num_dio > 7000 && self.num_dio <= 8000
      @scoregas = 4 # Score = 4
    elsif self.num_dio > 8000 && self.num_dio <= 9000
      @scoregas = 5 # Score = 5
    elsif self.num_dio > 9000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo_dis
    if self.num_ace <= 5
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 5 && self.num_ace <= 7
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 7 && self.num_ace <= 10
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 10 && self.num_ace <= 20
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 20 && self.num_ace <= 30
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 30
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE HORNO NORMA IEC
  #######################################################
  def hidrogeno_score_peso_tipo_hor
    if self.num_hid <= 200
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 200 && self.num_hid <= 250
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 250 && self.num_hid <= 300
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 300 && self.num_hid <= 500
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 500 && self.num_hid <= 700
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_hor
    if self.num_met <= 150
      @scoregas = 1 # Score = 1
    elsif self.num_met > 150 && self.num_met <= 170
      @scoregas = 2 # Score = 2
    elsif self.num_met > 170 && self.num_met <= 200
      @scoregas = 3 # Score = 3
    elsif self.num_met > 200 && self.num_met <= 400
      @scoregas = 4 # Score = 4
    elsif self.num_met > 400 && self.num_met <= 600
      @scoregas = 5 # Score = 5
    elsif self.num_met > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_hor
    if self.num_eti <= 200
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 200 && self.num_eti <= 350 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 350 && self.num_eti <= 400
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 400 && self.num_eti <= 450
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 450 && self.num_eti <= 500
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 500
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_hor
    if self.num_eta <= 150
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 150 && self.num_eta <= 170 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 170 && self.num_eta <= 210
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 210 && self.num_eta <= 260
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 260 && self.num_eta <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_hor
    if self.num_mon <= 800
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 800 && self.num_mon <= 900
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 900 && self.num_mon <= 1000
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 1000 && self.num_mon <= 1300
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 1300 && self.num_mon <= 1700
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 1700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo_hor
    if self.num_dio <= 6000 
      @scoregas = 1 # Score = 1
    elsif self.num_dio > 6000 && self.num_dio <= 7000
      @scoregas = 2 # Score = 2
    elsif self.num_dio > 7000 && self.num_dio <= 8000
      @scoregas = 3 # Score = 3
    elsif self.num_dio > 8000 && self.num_dio <= 9000
      @scoregas = 4 # Score = 4
    elsif self.num_dio > 9000 && self.num_dio <= 10000
      @scoregas = 5 # Score = 5
    elsif self.num_dio > 10000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE ACEITE SILICONA NORMA IEEE
  #######################################################

  def hidrogeno_score_peso_tipo_silicona
    if self.num_hid <= 200
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 200 && self.num_hid <= 400 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 400 && self.num_hid <= 600
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 600 && self.num_hid <= 1000
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 1000 && self.num_hid <= 1400
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 1400
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_silicona
    if self.num_met <= 100
      @scoregas = 1 # Score = 1
    elsif self.num_met > 100 && self.num_met <= 150 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 150 && self.num_met <= 200
      @scoregas = 3 # Score = 3
    elsif self.num_met > 200 && self.num_met <= 400
      @scoregas = 4 # Score = 4
    elsif self.num_met > 400 && self.num_met <= 600
      @scoregas = 5 # Score = 5
    elsif self.num_met > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_silicona
    if self.num_eti <= 30
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 30 && self.num_eti <= 45 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 45 && self.num_eti <= 60
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 60 && self.num_eti <= 120
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 120 && self.num_eti <= 180
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 180
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_silicona
    if self.num_eta <= 30
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 30 && self.num_eta <= 45 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 45 && self.num_eta <= 60
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 60 && self.num_eta <= 120
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 120 && self.num_eta <= 180
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 180
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_silicona
    if self.num_mon <= 3000
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 3000 && self.num_mon <= 4500 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 4500 && self.num_mon <= 6000
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 6000 && self.num_mon <= 7500
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 7500 && self.num_mon <= 9000
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 9000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo_silicona
    if self.num_dio <= 30000 
      @scoregas = 1 # Score = 1
    elsif self.num_dio > 30000 && self.num_dio <= 36000
      @scoregas = 2 # Score = 2
    elsif self.num_dio > 36000 && self.num_dio <= 42000
      @scoregas = 3 # Score = 3
    elsif self.num_dio > 42000 && self.num_dio <= 48000
      @scoregas = 4 # Score = 4
    elsif self.num_dio > 48000 && self.num_dio <= 54000
      @scoregas = 5 # Score = 5
    elsif self.num_dio > 54000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo_silicona
    if self.num_ace <= 1 
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 1 && self.num_ace <= 1.4 
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 1.4 && self.num_ace <= 2
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 2 && self.num_ace <= 4
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 4 && self.num_ace <= 6
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 6
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE ACEITE VEGETAL SOYA NORMA IEEE
  #######################################################

  def hidrogeno_score_peso_tipo_vegetal_soya
    if self.num_hid <= 112
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 112 && self.num_hid <= 150 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 150 && self.num_hid <= 200
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 200 && self.num_hid <= 250
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 250 && self.num_hid <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_vegetal_soya
    if self.num_met <= 20
      @scoregas = 1 # Score = 1
    elsif self.num_met > 20 && self.num_met <= 25 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 25 && self.num_met <= 30
      @scoregas = 3 # Score = 3
    elsif self.num_met > 30 && self.num_met <= 35
      @scoregas = 4 # Score = 4
    elsif self.num_met > 35 && self.num_met <= 40
      @scoregas = 5 # Score = 5
    elsif self.num_met > 40
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_vegetal_soya
    if self.num_eti <= 18
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 18 && self.num_eti <= 50 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 50 && self.num_eti <= 75
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 75 && self.num_eti <= 100
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 100 && self.num_eti <= 125
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 125
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_vegetal_soya
    if self.num_eta <= 232
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 232 && self.num_eta <= 250 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 250 && self.num_eta <= 300
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 300 && self.num_eta <= 350
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 350 && self.num_eta <= 400
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 400
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_vegetal_soya
    if self.num_mon <= 161
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 161 && self.num_mon <= 200 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 200 && self.num_mon <= 250
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 250 && self.num_mon <= 300
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 300 && self.num_mon <= 350
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 350
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo_vegetal_soya
    if self.num_ace <= 1 
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 1 && self.num_ace <= 5 
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 5 && self.num_ace <= 10
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 10 && self.num_ace <= 15
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 15 && self.num_ace <= 20
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 20
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end   

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE ACEITE VEGETAL GIRASOL NORMA IEEE
  #######################################################

  def hidrogeno_score_peso_tipo_vegetal_girasol
    if self.num_hid <= 35
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 35 && self.num_hid <= 40 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 40 && self.num_hid <= 45
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 45 && self.num_hid <= 50
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 50 && self.num_hid <= 55
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 55
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo_vegetal_girasol
    if self.num_met <= 25
      @scoregas = 1 # Score = 1
    elsif self.num_met > 25 && self.num_met <= 30 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 30 && self.num_met <= 35
      @scoregas = 3 # Score = 3
    elsif self.num_met > 35 && self.num_met <= 40
      @scoregas = 4 # Score = 4
    elsif self.num_met > 40 && self.num_met <= 45
      @scoregas = 5 # Score = 5
    elsif self.num_met > 45
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo_vegetal_girasol
    if self.num_eti <= 16
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 16 && self.num_eti <= 20 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 20 && self.num_eti <= 25
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 25 && self.num_eti <= 30
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 30 && self.num_eti <= 35
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 35
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo_vegetal_girasol
    if self.num_eta <= 58
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 58 && self.num_eta <= 100 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 100 && self.num_eta <= 150
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 150 && self.num_eta <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 200 && self.num_eta <= 250
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 250
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo_vegetal_girasol
    if self.num_mon <= 497
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 497 && self.num_mon <= 550 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 550 && self.num_mon <= 600
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 600 && self.num_mon <= 650
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 650 && self.num_mon <= 700
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo_vegetal_girasol
    if self.num_ace <= 0
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 0 && self.num_ace <= 5
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 5 && self.num_ace <= 10
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 10 && self.num_ace <= 15
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 15 && self.num_ace <= 20
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 20
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end   


  #######################################################
  # COLORES DE LMITES EN TRANSFORMADOR DE POTENCIA NORMA IEC
  #######################################################

  def color_hidrogeno_score_peso_tipo_pot
    if self.num_hid <= 150
      @scoregas = 1 # Score = 1
    elsif self.num_hid > 150 && self.num_hid <= 200 
      @scoregas = 2 # Score = 2
    elsif self.num_hid > 200 && self.num_hid <= 300
      @scoregas = 3 # Score = 3
    elsif self.num_hid > 300 && self.num_hid <= 500
      @scoregas = 4 # Score = 4
    elsif self.num_hid > 500 && self.num_hid <= 700
      @scoregas = 5 # Score = 5
    elsif self.num_hid > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def color_metano_score_peso_tipo_pot
    if self.num_met <= 130 
      @scoregas = 1 # Score = 1
    elsif self.num_met > 130 && self.num_met <= 150 
      @scoregas = 2 # Score = 2
    elsif self.num_met > 150 && self.num_met <= 200
      @scoregas = 3 # Score = 3
    elsif self.num_met > 200 && self.num_met <= 400
      @scoregas = 4 # Score = 4
    elsif self.num_met > 400 && self.num_met <= 600
      @scoregas = 5 # Score = 5
    elsif self.num_met > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def color_etileno_score_peso_tipo_pot
    if self.num_eti <= 280
      @scoregas = 1 # Score = 1
    elsif self.num_eti > 280 && self.num_eti <= 350 
      @scoregas = 2 # Score = 2
    elsif self.num_eti > 350 && self.num_eti <= 400
      @scoregas = 3 # Score = 3
    elsif self.num_eti > 400 && self.num_eti <= 450
      @scoregas = 4 # Score = 4
    elsif self.num_eti > 450 && self.num_eti <= 500
      @scoregas = 5 # Score = 5
    elsif self.num_eti > 500
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def color_etano_score_peso_tipo_pot
    if self.num_eta <= 90 
      @scoregas = 1 # Score = 1
    elsif self.num_eta > 90 && self.num_eta <= 110 
      @scoregas = 2 # Score = 2
    elsif self.num_eta > 110 && self.num_eta <= 150
      @scoregas = 3 # Score = 3
    elsif self.num_eta > 150 && self.num_eta <= 200
      @scoregas = 4 # Score = 4
    elsif self.num_eta > 200 && self.num_eta <= 300
      @scoregas = 5 # Score = 5
    elsif self.num_eta > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def color_monocarbono_score_peso_tipo_pot
    if self.num_mon <= 600 
      @scoregas = 1 # Score = 1
    elsif self.num_mon > 600 && self.num_mon <= 700 
      @scoregas = 2 # Score = 2
    elsif self.num_mon > 700 && self.num_mon <= 900
      @scoregas = 3 # Score = 3
    elsif self.num_mon > 900 && self.num_mon <= 1100
      @scoregas = 4 # Score = 4
    elsif self.num_mon > 1100 && self.num_mon <= 1400
      @scoregas = 5 # Score = 5
    elsif self.num_mon > 1400
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def color_diocarbono_score_peso_tipo_pot
    if self.num_dio <= 14000 
      @scoregas = 1 # Score = 1
    elsif self.num_dio > 14000 && self.num_dio <= 15000
      @scoregas = 2 # Score = 2
    elsif self.num_dio > 15000 && self.num_dio <= 16000
      @scoregas = 3 # Score = 3
    elsif self.num_dio > 16000 && self.num_dio <= 17000
      @scoregas = 4 # Score = 4
    elsif self.num_dio > 17000 && self.num_dio <= 18000
      @scoregas = 5 # Score = 5
    elsif self.num_dio > 18000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def color_acetileno_score_peso_tipo_pot
    if self.num_ace <= 20 
      @scoregas = 1 # Score = 1
    elsif self.num_ace > 20 && self.num_ace <= 30 
      @scoregas = 2 # Score = 2
    elsif self.num_ace > 30 && self.num_ace <= 40
      @scoregas = 3 # Score = 3
    elsif self.num_ace > 40 && self.num_ace <= 50
      @scoregas = 4 # Score = 4
    elsif self.num_ace > 50 && self.num_ace <= 80
      @scoregas = 5 # Score = 5
    elsif self.num_ace > 80
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      

  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEEE (TABLA 1)
  #######################################################

  def ieee_hidrogeno_tabla1 #H2
    ### LIMITE DE TIPO DE ACEITE MINTERAL
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2
        if @age <= 9 # O2/N2 <= 0.2 range 1-9
          @gas = 75  
        elsif  @age > 9 && @age <= 30  # O2/N2 <= 0.2 range 10-30
          @gas = 75  
        elsif  @age > 30  # O2/N2 <= 0.2 range >30
          @gas = 100      
        end
      else  # O2/N2 > 0.2 range all
         @gas = 40   
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA
    elsif self.transformer.oil_type_id == 4
      @gas = 200
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 112
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 35
      return @gas            
    end
  end

  def ieee_metano_tabla1 #CH4
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2
        if @age <= 9  # O2/N2 <= 0.2 range 1-9
          @gas = 45    
        elsif  @age > 9 && @age <= 30  # O2/N2 <= 0.2 range 10-30
          @gas = 90  
        elsif  @age > 30 # O2/N2 <= 0.2 range >30
          @gas = 110      
        end
      else # O2/N2 > 0.2 range all
         @gas = 20   
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA       
    elsif self.transformer.oil_type_id == 4
      @gas = 100
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 20
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 25
      return @gas         
    end      
  end

  def ieee_etano_tabla1 #C2H6
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2
        if @age <= 9 # O2/N2 <= 0.2 range 1-9
          @gas = 30   
        elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range 10-30
          @gas = 90  
        elsif  @age > 30  # O2/N2 <= 0.2 range >30 
          @gas = 150      
        end
      else # O2/N2 > 0.2 range all
         @gas = 15   
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA  
    elsif self.transformer.oil_type_id == 4
      @gas = 30
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 232
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 58
      return @gas         
    end      
  end

  def ieee_etileno_tabla1 #C2H4
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2
        if @age <= 9  # O2/N2 <= 0.2 range 1-9
          @gas = 20    
        elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range >30 
          @gas = 50  
        elsif  @age > 30  # O2/N2 <= 0.2 range >30 
          @gas = 90      
        end
      else
        if @age <= 9 # O2/N2 > 0.2 range 1-9
          @gas = 25    
        elsif  @age > 9  # O2/N2 > 0.2 range >9
          @gas = 60      
        end
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA
    elsif self.transformer.oil_type_id == 4
      @gas = 30
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 18
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 16
      return @gas         
    end      
  end

  def ieee_acetileno_tabla1 #C2H2
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2 # O2/N2 <= 0.2 range all
        @gas = 1   
      else # O2/N2 > 0.2 range all
        @gas = 2   
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA      
    elsif self.transformer.oil_type_id == 4
      @gas = 1
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 1
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 0
      return @gas         
    end      
  end

  def ieee_monocarbono_tabla1 #CO
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2 # O2/N2 <= 0.2 range all
        @gas = 900      
      else # O2/N2 > 0.2 range all
        @gas = 500   
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA  
    elsif self.transformer.oil_type_id == 4
      @gas = 3000
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      @gas = 161
      return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      @gas = 497
      return @gas         
    end      
  end

  def ieee_diocarbono_tabla1 #CO2
    if self.transformer.oil_type_id == 1
      @ox = self.num_oxi.to_d
      @ni = self.num_nit.to_d
      @condition =  @ox/@ni
      @age = self.transformer.str_edad
      if @condition <= 0.2
        if @age <= 9  # O2/N2 <= 0.2 range 1-9
          @gas = 5000    
        elsif  @age > 9  # O2/N2 <= 0.2 range >9 
          @gas = 10000      
        end  
      else
        if @age <= 9  # O2/N2 > 0.2 range 1-9
          @gas = 3500    
        elsif  @age > 9  # O2/N2 > 0.2 range >9 
          @gas = 5500      
        end          
      end
      return @gas
    ### LIMITE DE TIPO DE ACEITE SILICONA
    elsif self.transformer.oil_type_id == 4
      @gas = 30000
      return @gas
    ### LIMITE DE TIPO DE ACEITE VEGETAL SOYA     
    elsif self.transformer.oil_type_id == 5
      #@gas = 1000000
      #return @gas      
    ### LIMITE DE TIPO DE ACEITE VEGETAL GIRASOL
    elsif self.transformer.oil_type_id == 6
      #@gas = 1000000
      #return @gas         
    end      
  end

  #######################################################
  # COLORES DE LMITES EN TRANSFORMADOR NOMA IEEE
  #######################################################
  def ieee_color_hidrogeno
    @limit = self.ieee_hidrogeno_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_hid >= @limit
      @color = "red".html_safe  
    elsif self.num_hid >= @limit_10 && self.num_hid < @limit
      @color = "yellow".html_safe  
    elsif self.num_hid < @limit_10  
      @color = "green".html_safe  
    end
    return @color  
  end

  def ieee_color_metano
    @limit = self.ieee_metano_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_met >= @limit
      @color = "red".html_safe  
    elsif self.num_met >= @limit_10 && self.num_met < @limit
      @color = "yellow".html_safe  
    elsif self.num_met < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_etano
    @limit = self.ieee_etano_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eta >= @limit
      @color = "red".html_safe  
    elsif self.num_eta >= @limit_10 && self.num_eta < @limit
      @color = "yellow".html_safe  
    elsif self.num_eta < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_etileno
    @limit = self.ieee_etileno_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eti >= @limit
      @color = "red".html_safe  
    elsif self.num_eti >= @limit_10 && self.num_eti < @limit
      @color = "yellow".html_safe  
    elsif self.num_eti < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_acetileno
    @limit = self.ieee_acetileno_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_ace >= @limit
      @color = "red".html_safe  
    elsif self.num_ace >= @limit_10 && self.num_ace < @limit
      @color = "yellow".html_safe  
    elsif self.num_ace < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_monocarbono
    @limit = self.ieee_monocarbono_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_mon >= @limit
      @color = "red".html_safe  
    elsif self.num_mon >= @limit_10 && self.num_mon < @limit
      @color = "yellow".html_safe  
    elsif self.num_mon < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end  

  def ieee_color_diocarbono
    @limit = self.ieee_diocarbono_tabla1.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_dio >= @limit
      @color = "red".html_safe  
    elsif self.num_dio >= @limit_10 && self.num_dio < @limit
      @color = "yellow".html_safe  
    elsif self.num_dio < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end  

  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEC
  #######################################################

  def iec_hidrogeno
    if self.transformer.transformer_type_id == 1
      @gas = 150
    elsif self.transformer.transformer_type_id == 2
      @gas = 100
    elsif self.transformer.transformer_type_id == 3
      @gas = 200
    end 
    return @gas
  end

  def iec_metano
    if self.transformer.transformer_type_id == 1
      @gas = 130
    elsif self.transformer.transformer_type_id == 2
      @gas = 50
    elsif self.transformer.transformer_type_id == 3
      @gas = 150
    end 
    return @gas    
  end

  def iec_etileno
    if self.transformer.transformer_type_id == 1
      @gas = 280
    elsif self.transformer.transformer_type_id == 2
      @gas = 50
    elsif self.transformer.transformer_type_id == 3
      @gas = 200
    end 
    return @gas    
  end

  def iec_etano
    if self.transformer.transformer_type_id == 1
      @gas = 90
    elsif self.transformer.transformer_type_id == 2
      @gas = 50
    elsif self.transformer.transformer_type_id == 3
      @gas = 150
    end 
    return @gas    
  end

  def iec_monocarbono
    if self.transformer.transformer_type_id == 1
      @gas = 600
    elsif self.transformer.transformer_type_id == 2
      @gas = 200
    elsif self.transformer.transformer_type_id == 3
      @gas = 800
    end 
    return @gas    
  end  

  def iec_diocarbono
    if self.transformer.transformer_type_id == 1
      @gas = 14000
    elsif self.transformer.transformer_type_id == 2
      @gas = 5000
    elsif self.transformer.transformer_type_id == 3
      @gas = 6000
    end 
    return @gas    
  end    

  def iec_acetileno
    if self.transformer.transformer_type_id == 1
      @gas = 20
    elsif self.transformer.transformer_type_id == 2
      @gas = 5
    elsif self.transformer.transformer_type_id == 3
      @gas = 0
    end 
    return @gas    
  end  

  #######################################################
  # COLORES DE LIMITES EN TRANSFORMADOR NOMA IEC
  #######################################################
  
  def iec_color_hidrogeno
    @limit = self.iec_hidrogeno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_hid >= @limit
      @color = "red".html_safe  
    elsif self.num_hid >= @limit_10 && self.num_hid < @limit
      @color = "yellow".html_safe  
    elsif self.num_hid < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def iec_color_metano
    @limit = self.iec_metano.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_met >= @limit
      @color = "red".html_safe  
    elsif self.num_met >= @limit_10  && self.num_met < @limit
      @color = "yellow".html_safe  
    elsif self.num_met < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def iec_color_etano
    @limit = self.iec_etano.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eta >= @limit
      @color = "red".html_safe  
    elsif self.num_eta >= @limit_10  && self.num_eta < @limit
      @color = "yellow".html_safe  
    elsif self.num_eta < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def iec_color_etileno
    @limit = self.iec_etileno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eti >= @limit
      @color = "red".html_safe  
    elsif self.num_eti >= @limit_10  && self.num_eti < @limit
      @color = "yellow".html_safe  
    elsif self.num_eti < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def iec_color_acetileno
    @limit = self.iec_acetileno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_ace >= @limit
      @color = "red".html_safe  
    elsif self.num_ace >= @limit_10  && self.num_ace < @limit
      @color = "yellow".html_safe  
    elsif self.num_ace < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def iec_color_monocarbono
    @limit = self.iec_monocarbono.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_mon >= @limit
      @color = "red".html_safe  
    elsif self.num_mon >= @limit_10  && self.num_mon < @limit
      @color = "yellow".html_safe  
    elsif self.num_mon < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end  

  def iec_color_diocarbono
    @limit = self.iec_diocarbono.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_dio >= @limit
      @color = "red".html_safe  
    elsif self.num_dio >= @limit_10  && self.num_dio < @limit
      @color = "yellow".html_safe  
    elsif self.num_dio < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end  

  #######################################################
  # COLORES DE LIMITES EN TRANSFORMADOR NOMA IEC REPORT
  #######################################################
  
  def iec_color_hidrogeno_report
    @limit = self.iec_hidrogeno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_hid >= @limit
      @color = "danger".html_safe  
    elsif self.num_hid >= @limit_10 && self.num_hid < @limit
      @color = "warning".html_safe  
    elsif self.num_hid < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def iec_color_metano_report
    @limit = self.iec_metano.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_met >= @limit
      @color = "danger".html_safe  
    elsif self.num_met >= @limit_10  && self.num_met < @limit
      @color = "warning".html_safe  
    elsif self.num_met < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def iec_color_etano_report
    @limit = self.iec_etano.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eta >= @limit
      @color = "danger".html_safe  
    elsif self.num_eta >= @limit_10  && self.num_eta < @limit
      @color = "warning".html_safe  
    elsif self.num_eta < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def iec_color_etileno_report
    @limit = self.iec_etileno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_eti >= @limit
      @color = "danger".html_safe  
    elsif self.num_eti >= @limit_10  && self.num_eti < @limit
      @color = "warning".html_safe  
    elsif self.num_eti < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def iec_color_acetileno_report
    @limit = self.iec_acetileno.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_ace >= @limit
      @color = "danger".html_safe  
    elsif self.num_ace >= @limit_10  && self.num_ace < @limit
      @color = "warning".html_safe  
    elsif self.num_ace < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def iec_color_monocarbono_report
    @limit = self.iec_monocarbono.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_mon >= @limit
      @color = "danger".html_safe  
    elsif self.num_mon >= @limit_10  && self.num_mon < @limit
      @color = "warning".html_safe  
    elsif self.num_mon < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end  

  def iec_color_diocarbono_report
    @limit = self.iec_diocarbono.to_f
    @limit_10 = @limit.to_f - (@limit.to_f*10)/100

    if self.num_dio >= @limit
      @color = "danger".html_safe  
    elsif self.num_dio >= @limit_10  && self.num_dio < @limit
      @color = "warning".html_safe  
    elsif self.num_dio < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end  

  #######################################################
  # DIAGNOSTICO RATIO DE ROGERS
  #######################################################
  def rogers_c2h2_c2h4
    @rogers_c2h2_c2h4 = self.num_ace.to_f/self.num_eti.to_f
    return @rogers_c2h2_c2h4
  end

  def rogers_ch4_h2
    @rogers_ch4_h2 = self.num_met.to_f/self.num_hid.to_f
    return @rogers_ch4_h2
  end

  def rogers_c2h4_c2h6
    @rogers_c2h4_c2h6 = self.num_eti.to_f/self.num_eta.to_f
    return @rogers_c2h4_c2h6
  end    
  
  def rogers_cases
    @rogers_r1 =  self.rogers_c2h2_c2h4
    @rogers_r2 =  self.rogers_ch4_h2
    @rogers_r3 =  self.rogers_c2h4_c2h6

    if @rogers_r1 < 0.1 && @rogers_r2 > 0.1 && @rogers_r2 < 1.0 && @rogers_r3 < 1.0  #case 0
      return "Unidad Normal"
    elsif @rogers_r1 < 0.1 && @rogers_r2 < 0.1 && @rogers_r3 < 1.0  #case 1
      return "Densidad Arco de Baja energía."
    elsif @rogers_r1 > 0.1 && @rogers_r1 < 3.0 && @rogers_r2 > 0.1 && @rogers_r2 < 1.0 && @rogers_r3 > 3.0 #case 2
      return "Arco - Descarga de Alta energía"
    elsif @rogers_r1 < 0.1 && @rogers_r2 > 0.1 && @rogers_r2 < 1.0 && @rogers_r3 > 1.0 && @rogers_r3 < 3.0  #case 3
      return "Defecto de Baja Temperatura"
    elsif @rogers_r1 < 0.1 && @rogers_r2 > 1.0 && @rogers_r3 > 1.0 && @rogers_r3 < 3.0   #case 4
      return "Defecto Térmico < 700°C"                      
    elsif @rogers_r1 < 0.1 && @rogers_r2 > 1.0 && @rogers_r3 > 3.0 #case 5
      return "Defecto Térmico > 700°C"
    else #case 6
      return "No aplica diagnóstico"
    end    
  end
 
  #######################################################
  # # DIAGNOSTICO RATIO DE Doernenburg
  #######################################################

  def doe_ch4_h2
    @doe_ch4_h2 = self.num_met.to_f/self.num_hid.to_f
    return @doe_ch4_h2
  end

  def doe_c2h2_c2h4
    @doe_c2h2_c2h4 = self.num_ace.to_f/self.num_eti.to_f
    return @doe_c2h2_c2h4
  end

  def doe_c2h2_ch4
    @doe_c2h2_ch4 = self.num_ace.to_f/self.num_met.to_f
    return @doe_c2h2_ch4
  end    

  def doe_c2h6_c2h2
    @doe_c2h6_c2h2 = self.num_eta.to_f/self.num_ace.to_f
    return @doe_c2h6_c2h2
  end    

  def doe_cases
    @transformer_preservation_id = self.transformer.transformer_preservation_id
    @doe_r1 =  self.doe_ch4_h2
    @doe_r2 =  self.doe_c2h2_c2h4
    @doe_r3 =  self.doe_c2h2_ch4    
    @doe_r4 =  self.doe_c2h6_c2h2    
    # id = 1   is oil       
    # id = 2   is gas space
    if    @transformer_preservation_id == 1 && @doe_r1 > 1.0 && @doe_r2 < 0.75 && @doe_r3 < 0.3 && @doe_r4 > 0.4
      return "Descomposición Térmica"
    elsif @transformer_preservation_id == 1 && @doe_r1 < 0.1 && @doe_r3 < 0.3 && @doe_r4 > 0.4
      return "Descarga Parcial de Baja Densidad"
    elsif @transformer_preservation_id == 1 && @doe_r1 > 0.1 && @doe_r1 < 1.0 && @doe_r2 > 0.75 && @doe_r3 > 0.3 && @doe_r4 < 0.4
      return "Arco Descarga Parcial de Alta Densidad"  
    elsif @transformer_preservation_id == 2 && @doe_r1 > 0.1 && @doe_r2 < 1.0 && @doe_r3 < 0.1 && @doe_r4 > 0.2
      return "Descomposición Térmica"
    elsif @transformer_preservation_id == 2 && @doe_r1 < 0.01 && @doe_r3 < 0.1 && @doe_r4 > 0.2
      return "Descarga Parcial de Baja Densidad"
    elsif @transformer_preservation_id == 2 && @doe_r1 > 0.01 && @doe_r1 < 0.1 && @doe_r2 > 1.0 && @doe_r3 > 0.1 && @doe_r4 < 0.2
      return "Arco Descarga Parcial de Alta Densidad"        
    else
      return "No aplica diagnóstico" 
    end
  end

  #######################################################
  # DIAGNOSTICO NORMA IEC
  #######################################################
  
  def iec_c2h2_c2h4
    @iec_c2h2_c2h4 = self.num_ace.to_f/self.num_eti.to_f
    return @iec_c2h2_c2h4
  end

  def iec_ch4_h2
    @iec_ch4_h2 = self.num_met.to_f/self.num_hid.to_f
    return @iec_ch4_h2
  end

  def iec_c2h4_c2h6
    @iec_c2h4_c2h6 = self.num_eti.to_f/self.num_eta.to_f
    return @iec_c2h4_c2h6
  end

  def iec_cases
    @iec_r1 =  self.iec_c2h2_c2h4
    @iec_r2 =  self.iec_ch4_h2
    @iec_r3 =  self.iec_c2h4_c2h6        
   
    if self.iec_color_hidrogeno == "green" && self.iec_color_metano == "green" && self.iec_color_etano == "green" && self.iec_color_etileno == "green" && self.iec_color_acetileno == "green" && self.iec_color_monocarbono == "green" && self.iec_color_diocarbono == "green"
      return "No aplica diagnóstico" 
    else
      if @iec_r2 < 0.1 && @iec_r3 < 0.2
        return "PD = Descarga Parcial"
      elsif @iec_r1 > 1 && @iec_r2 >= 0.1 && @iec_r2 <= 0.5 && @iec_r3 > 1
        return "D1 = Descarga de Baja Energía"
      elsif @iec_r1 >= 0.6 && @iec_r1 <= 2.5 && @iec_r2 >= 0.1 && @iec_r2 <= 1 && @iec_r3 > 2
        return "D2 = Descarga de Alta Energía"  
      elsif @iec_r3 < 1 && @iec_r2 > 1
        return "T1 = Falla Térmica t < 300°C"
      elsif @iec_r1 < 0.1 && @iec_r2  > 1 && @iec_r3 >= 1 && @iec_r3 <= 4
        return "T2 = Falla Térmica 300°C < t < 700°C"
      elsif @iec_r1 < 0.2 && @iec_r2 > 1 && @iec_r3 > 4
        return "T3 = Falla Térmica t > 700°C"        
      else
        return "No aplica diagnóstico." 
      end    
    end

  end
 

  #######################################################
  # EVALUACION DE TABLA 1 EN TRANSFORMADOR NOMA IEEE
  #######################################################
  
  def ieee_hidrogeno_tabla1_eva
    @limit = self.ieee_hidrogeno_tabla1.to_f

    if self.num_hid > @limit
      @eva1tabla1 = "no"
    else
      @eva1tabla1 = "si"
    end

    return @eva1tabla1  
  end

  def ieee_metano_tabla1_eva
    @limit = self.ieee_metano_tabla1.to_f

    if self.num_met > @limit
      @eva2tabla1 = "no"
    else
      @eva2tabla1 = "si"
    end
    
    return @eva2tabla1  
  end

  def ieee_etano_tabla1_eva
    @limit = self.ieee_etano_tabla1.to_f

    if self.num_eta > @limit
      @eva3tabla1 = "no"
    else
      @eva3tabla1 = "si"
    end
    
    return @eva3tabla1  
  end

  def ieee_etileno_tabla1_eva
    @limit = self.ieee_etileno_tabla1.to_f

    if self.num_eti > @limit
      @eva4tabla1 = "no"
    else
      @eva4tabla1 = "si"
    end
    
    return @eva4tabla1  
  end

  def ieee_acetileno_tabla1_eva
    @limit = self.ieee_acetileno_tabla1.to_f

    if self.num_ace > @limit
      @eva5tabla1 = "no"
    else
      @eva5tabla1 = "si"
    end
    
    return @eva5tabla1  
  end

  def ieee_monocarbono_tabla1_eva
    @limit = self.ieee_monocarbono_tabla1.to_f

    if self.num_mon > @limit
      @eva6tabla1 = "no"
    else
      @eva6tabla1 = "si"
    end
    
    return @eva6tabla1  
  end  

  def ieee_diocarbono_tabla1_eva
    @limit = self.ieee_diocarbono_tabla1.to_f

    if self.num_dio > @limit
      @eva7tabla1 = "no"
    else
      @eva7tabla1 = "si"
    end
    
    return @eva7tabla1  
  end  


  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEEE (TABLA 2)
  #######################################################

  def ieee_hidrogeno_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 200      
    else # O2/N2 > 0.2 range all
      @gas = 90   
    end
    return @gas
  end

  def ieee_metano_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2
      if @age <= 9  # O2/N2 <= 0.2 range 1-9
        @gas = 100    
      elsif  @age > 9 && @age <= 30  # O2/N2 <= 0.2 range 10-30
        @gas = 150 
      elsif  @age > 30 # O2/N2 <= 0.2 range >30
        @gas = 200      
      end
    else # O2/N2 > 0.2 range all
      if @age <= 9 # O2/N2 <= 0.2 range 1-9
        @gas = 60  
      elsif  @age > 9 && @age <= 30  # O2/N2 <= 0.2 range 10-30
        @gas = 60  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30
        @gas = 30      
      end
    end
    return @gas
  end

  def ieee_etano_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2
      if @age <= 9 # O2/N2 <= 0.2 range 1-9
        @gas = 70   
      elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range 10-30
        @gas = 175  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30 
        @gas = 250      
      end
    else # O2/N2 > 0.2 range all
      if @age <= 9 # O2/N2 <= 0.2 range 1-9
        @gas = 30   
      elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range 10-30
        @gas = 40  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30 
        @gas = 40      
      end 
    end
    return @gas
  end

  def ieee_etileno_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2
      if @age <= 9  # O2/N2 <= 0.2 range 1-9
        @gas = 40    
      elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range >30 
        @gas = 95  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30 
        @gas = 175      
      end
    else
      if @age <= 9 # O2/N2 <= 0.2 range 1-9
        @gas = 80   
      elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range 10-30
        @gas = 125  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30 
        @gas = 125      
      end 
    end
    return @gas
  end

  def ieee_acetileno_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      if @age <= 9  # O2/N2 <= 0.2 range 1-9
        @gas = 2    
      elsif  @age > 9 && @age <= 30 # O2/N2 <= 0.2 range >30 
        @gas = 2  
      elsif  @age > 30  # O2/N2 <= 0.2 range >30 
        @gas = 4      
      end
    else # O2/N2 > 0.2 range all
      @gas = 7
    end
    return @gas
  end

  def ieee_monocarbono_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 1100      
    else # O2/N2 > 0.2 range all
      @gas = 600   
    end
    return @gas
  end

  def ieee_diocarbono_tabla2
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @age = self.transformer.str_edad
    if @condition <= 0.2
      if @age <= 9  # O2/N2 <= 0.2 range 1-9
        @gas = 7000    
      elsif  @age > 9  # O2/N2 <= 0.2 range >9 
        @gas = 14000      
      end  
    else
      if @age <= 9  # O2/N2 > 0.2 range 1-9
        @gas = 5000    
      elsif  @age > 9  # O2/N2 > 0.2 range >9 
        @gas = 8000      
      end          
    end
    return @gas
  end

  #######################################################
  # EVALUACION DE TABLA 2 EN TRANSFORMADOR NOMA IEEE
  #######################################################
  
  def ieee_hidrogeno_tabla2_eva
    @limit = self.ieee_hidrogeno_tabla2.to_f

    if self.num_hid > @limit
      @eva1tabla2 = "no"  
    else
      @eva1tabla2 = "si"
    end

    return @eva1tabla2
  end

  def ieee_metano_tabla2_eva
    @limit = self.ieee_metano_tabla2.to_f

    if self.num_met > @limit
      @eva2tabla2 = "no"
    else
      @eva2tabla2 = "si"
    end
    
    return @eva2tabla2  
  end

  def ieee_etano_tabla2_eva
    @limit = self.ieee_etano_tabla2.to_f

    if self.num_eta > @limit
      @eva3tabla2 = "no"
    else
      @eva3tabla2 = "si"
    end
    
    return @eva3tabla2
  end

  def ieee_etileno_tabla2_eva
    @limit = self.ieee_etileno_tabla2.to_f

    if self.num_eti > @limit
      @eva4tabla2 = "no"
    else
      @eva4tabla2 = "si"
    end
    
    return @eva4tabla2
  end

  def ieee_acetileno_tabla2_eva
    @limit = self.ieee_acetileno_tabla2.to_f

    if self.num_ace > @limit
      @eva5tabla2 = "no"
    else
      @eva5tabla2 = "si"
    end
    
    return @eva5tabla2
  end

  def ieee_monocarbono_tabla2_eva
    @limit = self.ieee_monocarbono_tabla2.to_f

    if self.num_mon > @limit
      @eva6tabla2 = "no"
    else
      @eva6tabla2 = "si"
    end
    
    return @eva6tabla2
  end  

  def ieee_diocarbono_tabla2_eva
    @limit = self.ieee_diocarbono_tabla2.to_f

    if self.num_dio > @limit
      @eva7tabla2 = "no"
    else
      @eva7tabla2 = "si"
    end
    
    return @eva7tabla2
  end  

  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEEE (TABLA 3)
  #######################################################

  def ieee_hidrogeno_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 40      
    else # O2/N2 > 0.2 range all
      @gas = 25   
    end
    return @gas
  end

  def ieee_metano_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 30      
    else # O2/N2 > 0.2 range all
      @gas = 10   
    end
    return @gas
  end

  def ieee_etano_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 25      
    else # O2/N2 > 0.2 range all
      @gas = 7   
    end
    return @gas
  end

  def ieee_etileno_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 20      
    else # O2/N2 > 0.2 range all
      @gas = 20   
    end
    return @gas
  end

  def ieee_monocarbono_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 250      
    else # O2/N2 > 0.2 range all
      @gas = 175   
    end
    return @gas
  end

  def ieee_diocarbono_tabla3
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    if @condition <= 0.2 # O2/N2 <= 0.2 range all
      @gas = 2500      
    else # O2/N2 > 0.2 range all
      @gas = 1750   
    end
    return @gas
  end

  #######################################################
  # EVALUACION DE TABLA 3 EN TRANSFORMADOR NOMA IEEE
  #######################################################
   
  def iee_table3_last_value 
    @table3_last_value  = Chromatographical.where("deleted= 0 AND transformer_id = ?", transformer_id ).order('date_rehearsal ASC')   
    return @table3_last_value
  end
  
  def ieee_hidrogeno_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_hid
    @penultimo = self.iee_table3_last_value.second_to_last.num_hid
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_hidrogeno_tabla3
      @eva1tabla3 = "no"  
    else
      @eva1tabla3 = "si"
    end

    return @eva1tabla3
  end

  def ieee_metano_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_met
    @penultimo = self.iee_table3_last_value.second_to_last.num_met
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_metano_tabla3
      @eva2tabla3 = "no"
    else
      @eva2tabla3 = "si"
    end
    
    return @eva2tabla3  
  end

  def ieee_etano_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_eta
    @penultimo = self.iee_table3_last_value.second_to_last.num_eta
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_etano_tabla3
      @eva3tabla3 = "no"
    else
      @eva3tabla3 = "si"
    end
    
    return @eva3tabla3
  end

  def ieee_etileno_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_eti
    @penultimo = self.iee_table3_last_value.second_to_last.num_eti
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_etileno_tabla3
      @eva4tabla3 = "no"
    else
      @eva4tabla3 = "si"
    end
    
    return @eva4tabla3
  end

  def ieee_acetileno_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_ace
    @penultimo = self.iee_table3_last_value.second_to_last.num_ace
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_acetileno_tabla3
      @eva5tabla3 = "no"
    else
      @eva5tabla3 = "si"
    end
    
    return @eva5tabla3
  end

  def ieee_monocarbono_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_mon
    @penultimo = self.iee_table3_last_value.second_to_last.num_mon
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_monocarbono_tabla3
      @eva6tabla3 = "no"
    else
      @eva6tabla3 = "si"
    end
    
    return @eva6tabla3
  end  

  def ieee_diocarbono_tabla3_eva
    @ultimo = self.iee_table3_last_value.last.num_dio
    @penultimo = self.iee_table3_last_value.second_to_last.num_dio
    @limit = @ultimo - @penultimo

    if @limit >= self.ieee_diocarbono_tabla3
      @eva7tabla3 = "no"
    else
      @eva7tabla3 = "si"
    end
    
    return @eva7tabla3
  end 

  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEEE (TABLA 4)
  #######################################################

  def iee_table4_last_value 
    @table4_last_value  = Chromatographical.where("deleted= 0 AND transformer_id = ?", transformer_id ).order('date_rehearsal ASC')   
    return @table4_last_value
  end

  def ieee_hidrogeno_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 50    
      elsif  @period >= 10 && @period <= 24
        @gas = 20      
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 25    
      elsif  @period >= 10 && @period <= 24 
        @gas = 10      
      end
    end
    return @gas
  end

  def ieee_metano_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 15    
      elsif  @period >= 10 && @period <= 24
        @gas = 10      
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 4    
      elsif  @period >= 10 && @period <= 24 
        @gas = 3      
      end
    end
    return @gas
  end

  def ieee_etano_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 15    
      elsif  @period >= 10 && @period <= 24
        @gas = 9      
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 3    
      elsif  @period >= 10 && @period <= 24 
        @gas = 2      
      end
    end
    return @gas
  end

  def ieee_etileno_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 10    
      elsif  @period >= 10 && @period <= 24
        @gas = 7      
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 7    
      elsif  @period >= 10 && @period <= 24 
        @gas = 5      
      end
    end
    return @gas
  end

  def ieee_monocarbono_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 200    
      elsif  @period >= 10 && @period <= 24
        @gas = 100      
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 100    
      elsif  @period >= 10 && @period <= 24 
        @gas = 80      
      end
    end
    return @gas
  end

  def ieee_diocarbono_tabla4
    @ox = self.num_oxi.to_d
    @ni = self.num_nit.to_d
    @condition =  @ox/@ni
    @period = self.transformer.str_edad
    if @condition <= 0.2
      if @period >= 4 && @period <= 9 
        @gas = 1750    
      elsif  @period >= 10 && @period <= 24
        @gas = 1000 
      end
    else
      if @period >= 4 && @period <= 9 
        @gas = 1000    
      elsif  @period >= 10 && @period <= 24 
        @gas = 800      
      end
    end
    return @gas
  end


  # RANSACKER
  ransacker :date_rehearsal do
    Arel.sql('strftime("%Y",date_rehearsal)')
  #  strftime('%Y',date_rehearsal)    SQLITE3
  #  YEAR(date_rehearsal)             MYSQL
  end

  # Pagination = 10
  self.per_page = 10


  # Modulo de Importación 
  def self.import(file, transformer_id)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)

    expected_headers = [
      'Fecha(dd/mm/aaaa)', 'H2-Hidrogeno', 'O2-Oxigeno', 'N2-Nitrogeno',
      'CH4-Metano', 'CO-Monoxido_Carbono', 'CO2-Dioxido_Carbono',
      'C2H4-Etileno', 'C2H6-Etano', 'C2H2-Acetileno'
    ]

    unless header == expected_headers
      raise "Formato Excel inválido.<br>Las columnas deben tener los siguientes nombres:<br> #{expected_headers.join(', ')}"
    end

    errors = []
    (2..spreadsheet.last_row).each do |i|
      chromatographical = new
      chromatographical.date_rehearsal = spreadsheet.cell(i, 'A')#Date.strptime(spreadsheet.cell(i, 'A'), '%d/%m/%Y') rescue nil
      chromatographical.num_hid = spreadsheet.cell(i, 'B')
      chromatographical.num_oxi = spreadsheet.cell(i, 'C')
      chromatographical.num_nit = spreadsheet.cell(i, 'D')
      chromatographical.num_met = spreadsheet.cell(i, 'E')
      chromatographical.num_mon = spreadsheet.cell(i, 'F')
      chromatographical.num_dio = spreadsheet.cell(i, 'G')
      chromatographical.num_eti = spreadsheet.cell(i, 'H')
      chromatographical.num_eta = spreadsheet.cell(i, 'I')
      chromatographical.num_ace = spreadsheet.cell(i, 'J')
      chromatographical.transformer_id = transformer_id
      chromatographical.deleted = 0

      unless chromatographical.save
        errors << "<br>Error en Línea #{i}: #{chromatographical.errors.full_messages.join(', ')}"
      end
    end

    errors
  end
 

  ##########################################
  def self.import_old(file,transformer_id)
    @errors = []
    spreadsheet = open_spreadsheet(file)
    (2..spreadsheet.last_row).each do |i| # 2 = empieza por la segunda fila
      column1 = spreadsheet.cell(i,'A')   # i = columna
      column2 = spreadsheet.cell(i,'B')
      column3 = spreadsheet.cell(i,'C')
      column4 = spreadsheet.cell(i,'D')
      column5 = spreadsheet.cell(i,'E')
      column6 = spreadsheet.cell(i,'F')
      column7 = spreadsheet.cell(i,'G')
      column8 = spreadsheet.cell(i,'H')
      column9 = spreadsheet.cell(i,'I')
      column10 =spreadsheet.cell(i,'J')
 
      chromatographical = Chromatographical.new(
       :date_rehearsal => column1, :num_hid => column2,
       :num_oxi => column3, :num_nit => column4,
       :num_met => column5, :num_mon => column6,
       :num_dio => column7 ,:num_eti => column8,
       :num_eta => column9 ,:num_ace => column10,
       :transformer_id => transformer_id,:deleted=> 0 )
      if chromatographical.save
        # stuff to do on successful save 
      else
        chromatographical.errors.full_messages.each do |message|
          @errors << "La información de la línea #{i}, <strong>columna #{message}</strong>".html_safe
        end
      end
    end  
    @errors #  <- need to return the @errors array     
  end

  ########################################

  def self.open_spreadsheet_old(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then  Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end





  private
    def save_default_values
      #self.deleted = 0    
    end 

    def save_default_values_job
      @transformer = self.transformer_id 
      @job_remover = IeeeDiagDetail.joins(ieee_diag: :transformer).where("transformer_id = ?",@transformer).destroy_all
      #@job_remover2 = IeeeDiag.where("deleted IN (1,2)").destroy_all
      @job_remover3 = IeeeDiag.where("transformer_id = ?",@transformer).destroy_all      
      @update_duval = ChromatographicalDuval.where("transformer_id = ?",@transformer).update_all(triangle_diag_first: nil, triangle_diag_second: nil, triangle_diag_third: nil, pentagon_diag_first: nil,pentagon_diag_second: nil,pentagon_diag_third: nil )
    end     

    def update_default_values_job
      @transformer = self.transformer_id 
      @job_remover = IeeeDiagDetail.joins(ieee_diag: :transformer).where("transformer_id = ?",@transformer).destroy_all
      #@job_remover2 = IeeeDiag.where("deleted IN (1,2)").destroy_all
      @job_remover3 = IeeeDiag.where("transformer_id = ?",@transformer).destroy_all  
      @update_duval = ChromatographicalDuval.where("transformer_id = ?",@transformer).update_all(triangle_diag_first: nil, triangle_diag_second: nil, triangle_diag_third: nil, pentagon_diag_first: nil,pentagon_diag_second: nil,pentagon_diag_third: nil )
    end   

    def update_nested_value
      self.deleted = 1 unless destroyed?   
    end    
             
    def update_transformer_report_fields
      transformer = Transformer.where("deleted=0 AND id = ?", self.transformer_id).update_all(con_cro: nil, rec_cro: nil, duval_triangle_first_image: nil, duval_pentagon_first_image: nil)
    end

end 
