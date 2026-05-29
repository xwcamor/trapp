class Physical < ApplicationRecord
  
  # Model relationships
  belongs_to :transformer
 
  # Actions using private
  before_save :save_default_values, :if => :new_record?
  after_save :update_default_values
  after_destroy :update_nested_value

  
  after_create :update_transformer_report_fields
  after_update :update_transformer_report_fields


  # Audit
  audited associated_with: :transformer

  # Validate
  validates_presence_of :date_rehearsal, message: 'No puede estar en blanco o vacío.' 
  validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "La Fecha ya existe."
  validates_presence_of :num_acid, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_pot,  message: 'No puede estar en blanco o vacío.' 
  #validates_presence_of :num_pot2, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_rig,  message: 'No puede estar en blanco o vacío.' 
  #validates_presence_of :num_rig2, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_ten,  message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_wat,  message: 'No puede estar en blanco o vacío.' 


  # Method string on action show
  def str_date_rehearsal
    if self.transformer.has_special_testing_fiq== 0
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
 
  #######################################################
  # CALCULO DE TRANSFORMADOR POR TIPO VOLTAGE NORMA IEEE
  #######################################################

  def suma_score_peso
    # tipo de aceite mineral  
    if self.transformer.oil_type_id == 1
      # suma de pesos de 69k
      if self.transformer.num_vol <= 69 
         suma_total_peso_tipo_low = 13.0
         suma_score_x_peso_tipo_low = rigidez_score_peso_tipo_low + tension_score_peso_tipo_low + acido_score_peso_tipo_low + humedad_score_peso_tipo_low + potencia_score_peso_tipo_low 
         sumatoria_dgaf_tipo_low =  suma_score_x_peso_tipo_low/suma_total_peso_tipo_low
         return sumatoria_dgaf_tipo_low

      # suma de pesos de 230k   
      elsif self.transformer.num_vol >= 69 && self.transformer.num_vol < 230 
         suma_total_peso_tipo_mid = 13.0 
         suma_score_x_peso_tipo_mid = rigidez_score_peso_tipo_mid + tension_score_peso_tipo_mid + acido_score_peso_tipo_mid + humedad_score_peso_tipo_mid + potencia_score_peso_tipo_mid
         sumatoria_dgaf_tipo_mid =  suma_score_x_peso_tipo_mid/suma_total_peso_tipo_mid
         return sumatoria_dgaf_tipo_mid

      # suma de pesos de >230k   
      elsif self.transformer.num_vol >= 230 
         suma_total_peso_tipo_high = 13.0 
         suma_score_x_peso_tipo_high = rigidez_score_peso_tipo_high + tension_score_peso_tipo_high + acido_score_peso_tipo_high + humedad_score_peso_tipo_high + potencia_score_peso_tipo_high
         sumatoria_dgaf_tipo_high =  suma_score_x_peso_tipo_high/suma_total_peso_tipo_high
         return sumatoria_dgaf_tipo_high
      end
    # tipo de aceite silicona  
    elsif self.transformer.oil_type_id == 4
      suma_total_peso_tipo_silicona = 11.0  
      suma_score_x_peso_tipo_silicona = rigidez_score_peso_tipo_silicona + acido_score_peso_tipo_silicona + humedad_score_peso_tipo_silicona + potencia_score_peso_tipo_silicona
      sumatoria_dgaf_tipo_silicona =  suma_score_x_peso_tipo_silicona/suma_total_peso_tipo_silicona
      return sumatoria_dgaf_tipo_silicona 

    # tipo de aceite vegetal soya   
    elsif self.transformer.oil_type_id == 5
      # suma de pesos de 69k
      if self.transformer.num_vol <= 69 
         suma_total_peso_tipo_low_soya = 13.0
         suma_score_x_peso_tipo_low_soya = rigidez_score_peso_tipo_low_soya + tension_score_peso_tipo_low_soya + acido_score_peso_tipo_low_soya + humedad_score_peso_tipo_low_soya + potencia_score_peso_tipo_low_soya 
         sumatoria_dgaf_tipo_low_soya =  suma_score_x_peso_tipo_low_soya/suma_total_peso_tipo_low_soya
         return sumatoria_dgaf_tipo_low_soya

      # suma de pesos de 230k   
      elsif self.transformer.num_vol >= 69 && self.transformer.num_vol < 230 
         suma_total_peso_tipo_mid_soya = 13.0 
         suma_score_x_peso_tipo_mid_soya = rigidez_score_peso_tipo_mid_soya + tension_score_peso_tipo_mid_soya + acido_score_peso_tipo_mid_soya + humedad_score_peso_tipo_mid_soya + potencia_score_peso_tipo_mid_soya
         sumatoria_dgaf_tipo_mid_soya =  suma_score_x_peso_tipo_mid_soya/suma_total_peso_tipo_mid_soya
         return sumatoria_dgaf_tipo_mid_soya

      # suma de pesos de >230k   
      elsif self.transformer.num_vol >= 230 
         suma_total_peso_tipo_high_soya = 13.0 
         suma_score_x_peso_tipo_high_soya = rigidez_score_peso_tipo_high_soya + tension_score_peso_tipo_high_soya + acido_score_peso_tipo_high_soya + humedad_score_peso_tipo_high_soya + potencia_score_peso_tipo_high_soya
         sumatoria_dgaf_tipo_high_soya =  suma_score_x_peso_tipo_high_soya/suma_total_peso_tipo_high_soya
         return sumatoria_dgaf_tipo_high_soya
      end    

    # tipo de aceite vegetal girasol  
    elsif self.transformer.oil_type_id == 6
      # suma de pesos de 69k
      if self.transformer.num_vol <= 69 
         suma_total_peso_tipo_low_girasol = 13.0
         suma_score_x_peso_tipo_low_girasol = rigidez_score_peso_tipo_low_girasol + tension_score_peso_tipo_low_girasol + acido_score_peso_tipo_low_girasol + humedad_score_peso_tipo_low_girasol + potencia_score_peso_tipo_low_girasol 
         sumatoria_dgaf_tipo_low_girasol =  suma_score_x_peso_tipo_low_girasol/suma_total_peso_tipo_low_girasol
         return sumatoria_dgaf_tipo_low_girasol

      # suma de pesos de 230k   
      elsif self.transformer.num_vol >= 69 && self.transformer.num_vol < 230 
         suma_total_peso_tipo_mid_girasol= 13.0 
         suma_score_x_peso_tipo_mid_girasol = rigidez_score_peso_tipo_mid_girasol + tension_score_peso_tipo_mid_girasol + acido_score_peso_tipo_mid_girasol + humedad_score_peso_tipo_mid_girasol + potencia_score_peso_tipo_mid_girasol
         sumatoria_dgaf_tipo_mid_girasol =  suma_score_x_peso_tipo_mid_girasol/suma_total_peso_tipo_mid_girasol
         return sumatoria_dgaf_tipo_mid_girasol

      # suma de pesos de >230k   
      elsif self.transformer.num_vol >= 230 
         suma_total_peso_tipo_high_girasol = 13.0 
         suma_score_x_peso_tipo_high_girasol = rigidez_score_peso_tipo_high_girasol + tension_score_peso_tipo_high_girasol + acido_score_peso_tipo_high_girasol + humedad_score_peso_tipo_high_girasol + potencia_score_peso_tipo_high_girasol
         sumatoria_dgaf_tipo_high_girasol =  suma_score_x_peso_tipo_high_girasol/suma_total_peso_tipo_high_girasol
         return sumatoria_dgaf_tipo_high_girasol
      end            
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
      return 24
    elsif suma_score_peso >= 1.2 && suma_score_peso < 1.5
      return 18
    elsif suma_score_peso >= 1.5 && suma_score_peso < 2
      return 12
    elsif suma_score_peso >= 2 && suma_score_peso < 3
      return 6
    elsif suma_score_peso >= 3
      return 0
    end
  end

  def dgaf_score_ratio
    if    self.dgaf_score == 24
      return 4
    elsif self.dgaf_score == 18
      return 3
    elsif self.dgaf_score == 12
      return 2
    elsif self.dgaf_score == 6
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
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe + "Medio".to_s
    elsif self.diag_status == 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Malo".to_s
    elsif self.diag_status == 1
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Muy Malo".to_s
    end
  end
 

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE LOW VOLTAGE: ACEITE MINERAL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_low
    if self.num_rig >= 40
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 35 && self.num_rig < 40 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 30 && self.num_rig <= 35
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 30
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_low
    if self.num_ten >= 25
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 20 && self.num_ten < 25 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 15 && self.num_ten <= 20
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 15
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_low
    if self.num_acid <= 0.05
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.05 && self.num_acid <= 0.10 
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 0.10 && self.num_acid < 0.20
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 0.20
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_low
    if self.num_wat <= 20
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 20 && self.num_wat <= 30 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 30 && self.num_wat <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_low
    if self.num_pot <= 0.1
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 0.1 && self.num_pot <= 0.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 0.5 && self.num_pot <= 1
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 1
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE MID VOLTAGE: ACEITE MINERAL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_mid
    if self.num_rig >= 47
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 40 && self.num_rig < 47 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 35 && self.num_rig <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 35
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_mid
    if self.num_ten >= 30
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 23 && self.num_ten < 30 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 18 && self.num_ten <= 23
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 18
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_mid
    if self.num_acid <= 0.04
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.04 && self.num_acid <= 0.10 
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 0.10 && self.num_acid < 0.15
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 0.15
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_mid
    if self.num_wat <= 20
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 20 && self.num_wat <= 30 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 30 && self.num_wat <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_mid
    if self.num_pot <= 0.1
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 0.1 && self.num_pot <= 0.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 0.5 && self.num_pot <= 1
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 1
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE HIGH VOLTAGE: ACEITE MINERAL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_high
    if self.num_rig >= 50
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 45 && self.num_rig < 50 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 40 && self.num_rig <= 45
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_high
    if self.num_ten >= 32
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 25 && self.num_ten < 32 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 20 && self.num_ten <= 25
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 20
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_high
    if self.num_acid <= 0.03
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.03 && self.num_acid <= 0.07
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 0.07 && self.num_acid < 0.10
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 0.10
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_high
    if self.num_wat <= 20
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 20 && self.num_wat <= 30 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 30 && self.num_wat <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_high
    if self.num_pot <= 0.1
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 0.1 && self.num_pot <= 0.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 0.5 && self.num_pot <= 1
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 1
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE ACEITE SILICONA  NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_silicona
    if self.num_rig >= 25
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 22 && self.num_rig < 25 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 20 && self.num_rig <= 22
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 20
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_silicona
    if self.num_acid <= 0.2
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.2 && self.num_acid <= 0.4
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 0.4 && self.num_acid < 0.8
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 0.8
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_silicona
    if self.num_wat <= 100
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 100 && self.num_wat <= 150
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 150 && self.num_wat <= 200
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 200
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_silicona
    if self.num_pot <= 0.2
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 0.2 && self.num_pot <= 0.4
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 0.4 && self.num_pot <= 0.8
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 0.8
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE LOW VOLTAGE: TIPO DE ACEITE VEGETAL SOYA NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_low_soya
    if self.num_rig >= 40
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 35 && self.num_rig < 40 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 30 && self.num_rig <= 35
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 30
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_low_soya
    if self.num_ten >= 10
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 10 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_low_soya
    if self.num_acid <= 0.5
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.5 && self.num_acid <= 1
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_low_soya
    if self.num_wat <= 450
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 450 && self.num_wat <= 500 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 500 && self.num_wat <= 550
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 550
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_low_soya
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE MID VOLTAGE: TIPO DE ACEITE VEGETAL SOYA NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_mid_soya
    if self.num_rig >= 47
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 40 && self.num_rig < 47 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 35 && self.num_rig <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 35
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_mid_soya
    if self.num_ten >= 12
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 12 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_mid_soya
    if self.num_acid <= 0.3
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.3 && self.num_acid <= 1 
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_mid_soya
    if self.num_wat <= 350
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 350 && self.num_wat <= 400 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 400 && self.num_wat <= 450
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 450
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_mid_soya
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE HIGH VOLTAGE: TIPO DE ACEITE VEGETAL SOYA NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_high_soya
    if self.num_rig >= 50
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 45 && self.num_rig < 50 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 40 && self.num_rig <= 45
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_high_soya
    if self.num_ten >= 14
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 14 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_high_soya
    if self.num_acid <= 0.3
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.3 && self.num_acid <= 1
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_high_soya
    if self.num_wat <= 200
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 200 && self.num_wat <= 300 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 300 && self.num_wat <= 400
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 400
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_high_soya
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE LOW VOLTAGE: TIPO DE ACEITE VEGETAL GIRASOL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_low_girasol
    if self.num_rig >= 40
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 35 && self.num_rig < 40 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 30 && self.num_rig <= 35
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 30
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_low_girasol
    if self.num_ten >= 10
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 10 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_low_girasol
    if self.num_acid <= 0.5
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.5 && self.num_acid <= 1 
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_low_girasol
    if self.num_wat <= 450
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 450 && self.num_wat <= 500 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 500 && self.num_wat <= 550
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 550
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_low_girasol
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE MID VOLTAGE: TIPO DE ACEITE VEGETAL GIRASOL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_mid_girasol
    if self.num_rig >= 47
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 40 && self.num_rig < 47 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 35 && self.num_rig <= 40
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 35
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_mid_girasol
    if self.num_ten >= 12
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 12 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_mid_girasol
    if self.num_acid <= 0.3
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.3 && self.num_acid <= 1
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_mid_girasol
    if self.num_wat <= 350
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 350 && self.num_wat <= 400 
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 400 && self.num_wat <= 450
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 450
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_mid_girasol
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE HIGH VOLTAGE: TIPO DE ACEITE VEGETAL GIRASOL NORMA IEEE
  #######################################################

  def rigidez_score_peso_tipo_high_girasol
    if self.num_rig >= 50
      @scoretrial = 1 # Score = 1
    elsif self.num_rig > 45 && self.num_rig < 50 
      @scoretrial = 2 # Score = 2
    elsif self.num_rig > 40 && self.num_rig <= 45
      @scoretrial = 3 # Score = 3
    elsif self.num_rig <= 40
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def tension_score_peso_tipo_high_girasol
    if self.num_ten >= 14
      @scoretrial = 1 # Score = 1
    elsif self.num_ten > 8 && self.num_ten < 14 
      @scoretrial = 2 # Score = 2
    elsif self.num_ten > 6 && self.num_ten <= 8
      @scoretrial = 3 # Score = 3
    elsif self.num_ten <= 6
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 2 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def acido_score_peso_tipo_high_girasol
    if self.num_acid <= 0.3
      @scoretrial = 1 # Score = 1
    elsif self.num_acid > 0.3 && self.num_acid <= 1
      @scoretrial = 2 # Score = 2
    elsif self.num_acid > 1 && self.num_acid < 1.5
      @scoretrial = 3 # Score = 3
    elsif self.num_acid >= 1.5
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 1 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def humedad_score_peso_tipo_high_girasol
    if self.num_wat <= 200
      @scoretrial = 1 # Score = 1
    elsif self.num_wat > 200 && self.num_wat <= 300
      @scoretrial = 2 # Score = 2
    elsif self.num_wat > 300 && self.num_wat <= 400
      @scoretrial = 3 # Score = 3
    elsif self.num_wat > 400
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 4 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  def potencia_score_peso_tipo_high_girasol
    if self.num_pot <= 3
      @scoretrial = 1 # Score = 1
    elsif self.num_pot > 3 && self.num_pot <= 3.5
      @scoretrial = 2 # Score = 2
    elsif self.num_pot > 3.5 && self.num_pot <= 4
      @scoretrial = 3 # Score = 3
    elsif self.num_pot > 4
      @scoretrial = 4 # Score = 4
    end
    @pesotrial = 3 # Peso Trial                                       
    @dgatrial = @scoretrial * @pesotrial
    return @dgatrial  # Resultado Score X Peso
  end

  #######################################################
  # LIMITES DE PARAMETROS EN TRANSFORMADOR NOMA IEEE
  #######################################################

  def ieee_num_rig
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 40  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 40 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 40                 
      end
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 47  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 47 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 47          
      end        
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 50 
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 50 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 50           
      end             
    end
    return @physical_trial
  end

  def ieee_num_rig2
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 25  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 40 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 40                 
      end
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 25  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 47 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 47          
      end        
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 25 
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 25  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 50 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 50           
      end             
    end
    return @physical_trial
  end  

  def ieee_num_pot
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.5  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end        
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.5  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end        
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.5    
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end          
    end
    return @physical_trial
  end

  def ieee_num_pot2
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 5 
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2  
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end        
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 5  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end        
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 5  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 3 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 3          
      end          
    end
    return @physical_trial
  end

  def ieee_num_ten
    @voltage = self.transformer.num_vol
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 25 
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 10 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 10  
      end         
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 30 
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 12 
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 12  
      end         
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 32 
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 14
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 14 
      end          
    end
    return @physical_trial
  end

  def ieee_num_acid
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.20  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 0.5
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 0.5 
      end        
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.15  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 0.3
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 0.3         
      end        
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 0.10  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 0.2
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 0.3
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 0.3         
      end            
    end
    return @physical_trial
  end

  def ieee_num_wat
    @voltage = self.transformer.num_vol
    @oil_type = self.transformer.oil_type_id
    if @voltage <= 69 # voltaje <= 69
      if @oil_type == 1 # MINERAL
        @physical_trial = 35  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 100 
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 450
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 450         
      end        
    elsif  @voltage > 69 && @voltage < 230 # voltaje > 69 - < 230
      if @oil_type == 1 # MINERAL
        @physical_trial = 25 
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 100
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 350
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 350         
      end         
    elsif  @voltage >= 230  # voltaje >= 230
      if @oil_type == 1 # MINERAL  
        @physical_trial = 20  
      elsif @oil_type == 4 # SILICONA
        @physical_trial = 100
      elsif @oil_type == 5 # VEGETAL SOYA
        @physical_trial = 200
      elsif @oil_type == 6 # VEGETAL GIRASOL
        @physical_trial = 200         
      end            
    end
    return @physical_trial
  end

  #######################################################
  # COLORES DE LIMITES EN TRANSFORMADOR NOMA IEEE - CAPSULAS
  #######################################################

  def ieee_color_num_rig
    @limit = self.ieee_num_rig.to_f   
    @limit_10 = @limit.to_f + (@limit.to_f*10)/100  

    if self.num_rig < @limit
      @color = "red".html_safe  
    elsif self.num_rig >= @limit && self.num_rig < @limit_10
      @color = "yellow".html_safe  
    elsif self.num_rig >= @limit_10
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_rig2
    @limit = self.ieee_num_rig2.to_f   
    @limit_10 = @limit.to_f + (@limit.to_f*10)/100  

    if self.num_rig2 < @limit
      @color = "red".html_safe  
    elsif self.num_rig2 >= @limit && self.num_rig2 < @limit_10
      @color = "yellow".html_safe  
    elsif self.num_rig2 >= @limit_10
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_ten
    @limit = self.ieee_num_ten
    @limit_10 = @limit + (@limit*10)/100  

    if self.num_ten < @limit
      @color = "red".html_safe  
    elsif self.num_ten >= @limit && self.num_ten < @limit_10
      @color = "yellow".html_safe  
    elsif self.num_ten >= @limit_10
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_pot
    @limit = self.ieee_num_pot
    @limit_10 = @limit - (@limit*10)/100

    if self.num_pot >= @limit
      @color = "red".html_safe  
    elsif self.num_pot >= @limit_10 && self.num_pot < @limit
      @color = "yellow".html_safe  
    elsif self.num_pot < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_pot2
    @limit = self.ieee_num_pot2
    @limit_10 = @limit - (@limit*10)/100

    if self.num_pot2 >= @limit
      @color = "red".html_safe  
    elsif self.num_pot2 >= @limit_10 && self.num_pot2 < @limit
      @color = "yellow".html_safe  
    elsif self.num_pot2 < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_acid
    @limit = self.ieee_num_acid
    @limit_10 = @limit - (@limit*10)/100

    if self.num_acid >= @limit
      @color = "red".html_safe  
    elsif self.num_acid >= @limit_10 && self.num_acid < @limit
      @color = "yellow".html_safe  
    elsif self.num_acid < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  def ieee_color_num_wat
    @limit = self.ieee_num_wat
    @limit_10 = @limit - (@limit*10)/100

    if self.num_wat >= @limit
      @color = "red".html_safe  
    elsif self.num_wat >= @limit_10 && self.num_wat < @limit
      @color = "yellow".html_safe  
    elsif self.num_wat < @limit_10  
      @color = "green".html_safe  
    end
    return @color
  end

  #######################################################
  # COLORES DE LIMITES EN TRANSFORMADOR NOMA IEEE - CIRCULOS
  #######################################################

  def ieee_color_num_rig_circle
    @limit = self.ieee_num_rig.to_f   
    @limit_10 = @limit.to_f + (@limit.to_f*10)/100  

    if self.num_rig < @limit
      @color = "<i class='fa fa-circle fa-fw text-red me-2 fs-10px'></i>".html_safe  
    elsif self.num_rig >= @limit && self.num_rig < @limit_10
      @color = "<i class='fa fa-circle fa-fw text-yellow me-2 fs-10px'></i>".html_safe  
    elsif self.num_rig >= @limit_10
      @color = "<i class='fa fa-circle fa-fw text-green me-2 fs-10px'></i>".html_safe  
    end
    return @color
  end

  def ieee_color_num_ten_circle
    @limit = self.ieee_num_ten
    @limit_10 = @limit + (@limit*10)/100  

    if self.num_ten < @limit
      @color = "<i class='fa fa-circle fa-fw text-red me-2 fs-10px'></i>".html_safe  
    elsif self.num_ten >= @limit && self.num_ten < @limit_10
      @color = "<i class='fa fa-circle fa-fw text-yellow me-2 fs-10px'></i>".html_safe  
    elsif self.num_ten >= @limit_10
      @color = "<i class='fa fa-circle fa-fw text-green me-2 fs-10px'></i>".html_safe  
    end
    return @color
  end

  def ieee_color_num_pot_circle
    @limit = self.ieee_num_pot
    @limit_10 = @limit - (@limit*10)/100

    if self.num_pot >= @limit
      @color = "<i class='fa fa-circle fa-fw text-red me-2 fs-10px'></i>".html_safe  
    elsif self.num_pot >= @limit_10 && self.num_pot < @limit
      @color = "<i class='fa fa-circle fa-fw text-yellow me-2 fs-10px'></i>".html_safe  
    elsif self.num_pot < @limit_10  
      @color = "<i class='fa fa-circle fa-fw text-green me-2 fs-10px'></i>".html_safe  
    end
    return @color
  end

  def ieee_color_num_acid_circle
    @limit = self.ieee_num_acid
    @limit_10 = @limit - (@limit*10)/100

    if self.num_acid >= @limit
      @color = "<i class='fa fa-circle fa-fw text-red me-2 fs-10px'></i>".html_safe  
    elsif self.num_acid >= @limit_10 && self.num_acid < @limit
      @color = "<i class='fa fa-circle fa-fw text-yellow me-2 fs-10px'></i>".html_safe  
    elsif self.num_acid < @limit_10  
      @color = "<i class='fa fa-circle fa-fw text-green me-2 fs-10px'></i>".html_safe  
    end
    return @color
  end

  def ieee_color_num_wat_circle
    @limit = self.ieee_num_wat
    @limit_10 = @limit - (@limit*10)/100

    if self.num_wat >= @limit
      @color = "<i class='fa fa-circle fa-fw text-red me-2 fs-10px'></i>".html_safe  
    elsif self.num_wat >= @limit_10 && self.num_wat < @limit
      @color = "<i class='fa fa-circle fa-fw text-yellow me-2 fs-10px'></i>".html_safe  
    elsif self.num_wat < @limit_10  
      @color = "<i class='fa fa-circle fa-fw text-green me-2 fs-10px'></i>".html_safe  
    end
    return @color
  end


  #######################################################
  # COLORES DE LIMITES EN TRANSFORMADOR NOMA IEEE - REPORTES
  #######################################################

  def ieee_color_num_rig_report
    @limit = self.ieee_num_rig.to_f   
    @limit_10 = @limit.to_f + (@limit.to_f*10)/100  

    if self.num_rig < @limit
      @color = "danger".html_safe  
    elsif self.num_rig >= @limit && self.num_rig < @limit_10
      @color = "warning".html_safe  
    elsif self.num_rig >= @limit_10
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_rig2_report
    @limit = self.ieee_num_rig2.to_f   
    @limit_10 = @limit.to_f + (@limit.to_f*10)/100  

    if self.num_rig2 < @limit
      @color = "danger".html_safe  
    elsif self.num_rig2 >= @limit && self.num_rig2 < @limit_10
      @color = "warning".html_safe  
    elsif self.num_rig2 >= @limit_10
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_ten_report
    @limit = self.ieee_num_ten
    @limit_10 = @limit + (@limit*10)/100  

    if self.num_ten < @limit
      @color = "danger".html_safe  
    elsif self.num_ten >= @limit && self.num_ten < @limit_10
      @color = "yellow".html_safe  
    elsif self.num_ten >= @limit_10
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_pot_report
    @limit = self.ieee_num_pot
    @limit_10 = @limit - (@limit*10)/100

    if self.num_pot >= @limit
      @color = "danger".html_safe  
    elsif self.num_pot >= @limit_10 && self.num_pot < @limit
      @color = "warning".html_safe  
    elsif self.num_pot < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_pot2_report
    @limit = self.ieee_num_pot2
    @limit_10 = @limit - (@limit*10)/100

    if self.num_pot2 >= @limit
      @color = "danger".html_safe  
    elsif self.num_pot2 >= @limit_10 && self.num_pot2 < @limit
      @color = "warning".html_safe  
    elsif self.num_pot2 < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_acid_report
    @limit = self.ieee_num_acid
    @limit_10 = @limit - (@limit*10)/100

    if self.num_acid >= @limit
      @color = "danger".html_safe  
    elsif self.num_acid >= @limit_10 && self.num_acid < @limit
      @color = "warning".html_safe  
    elsif self.num_acid < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  def ieee_color_num_wat_report
    @limit = self.ieee_num_wat
    @limit_10 = @limit - (@limit*10)/100

    if self.num_wat >= @limit
      @color = "danger".html_safe  
    elsif self.num_wat >= @limit_10 && self.num_wat < @limit
      @color = "warning".html_safe  
    elsif self.num_wat < @limit_10  
      @color = "success".html_safe  
    end
    return @color
  end

  # RANSACKER
  ransacker :date_rehearsal do
    Arel.sql('strftime("%Y",date_rehearsal)')
  #  strftime('%Y',date_rehearsal)    SQLITE3
  #  YEAR(date_rehearsal)             MYSQL
  end


  # Modulo de Importación 
  def self.import(file, transformer_id)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)

    expected_headers = [
      'Fecha(dd/mm/aaaa)', 'Número_Ácido_D974', 'Factor_Potencia_25', 'Factor_Potencia_100',
      'Rigidez_Dieléctrica_D1816', 'Rigidez_Dieléctrica_D877', 'Ténsion_Dieléctrica_D971',
      'Contenido_Agua_D1513'
    ]

    unless header == expected_headers
      raise "Formato Excel inválido.<br>Las columnas deben tener los siguientes nombres:<br> #{expected_headers.join(', ')}"
    end

    errors = []
    (2..spreadsheet.last_row).each do |i|
      physical = new
      physical.date_rehearsal = spreadsheet.cell(i, 'A') #Date.strptime(spreadsheet.cell(i, 'A'), '%d/%m/%Y') rescue nil
      physical.num_acid = spreadsheet.cell(i, 'B')
      physical.num_pot  = spreadsheet.cell(i, 'C')
      physical.num_pot2 = spreadsheet.cell(i, 'D')
      physical.num_rig  = spreadsheet.cell(i, 'E')
      physical.num_rig2 = spreadsheet.cell(i, 'F')
      physical.num_ten  = spreadsheet.cell(i, 'G')
      physical.num_wat  = spreadsheet.cell(i, 'H')
      physical.transformer_id = transformer_id
      physical.deleted = 0

      unless physical.save
        errors << "<br>Error en Línea #{i}: #{physical.errors.full_messages.join(', ')}"
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
 
      physical = Physical.new(
       :date_rehearsal => column1, :num_acid => column2,
       :num_pot => column3, :num_pot2 => column4,
       :num_rig => column5, :num_rig2 => column6,
       :num_ten => column7,  :num_wat => column8,
       :transformer_id => transformer_id,:deleted => 0 )
      if physical.save
        # stuff to do on successful save 
      else
        physical.errors.full_messages.each do |message|
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


  # Pagination = 10
  #self.per_page = 10

  private
    def save_default_values
      #self.deleted = 0    
      #self.num_pot2 = 0   if self.num_pot2.nil?    
      #self.num_rig2 = 0   if self.num_rig2.nil? 
      self.diag_status = self.str_diag_status
    end 

    def update_default_values
     Physical.where('id = ?',self.id).update_all(diag_status: self.str_diag_status)
    end 
    
    def update_nested_value
      self.deleted = 1 unless destroyed?   
    end    

    def update_transformer_report_fields
      transformer = Transformer.where("deleted=0 AND id = ?", self.transformer_id).update_all(con_fiq: nil, rec_fiq: nil)
    end

end 
