class Electrical < ApplicationRecord
  # Model relationships
  belongs_to :transformer
 
  
   # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :num_serie, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
  # Method string on action show
  def str_date_rehearsal
    self.date_rehearsal.strftime("%d/%m/%Y")
  end

  def suma_gases_combustibles
    self.hidrogeno + self.metano + self.monocarbono + self.etileno + self.etano + self.acetileno
  end

  #######################################################
  # CALCULO DE TRIANGULO DUVAL
  #######################################################
  def suma_total_gases
    self.hidrogeno + self.oxigeno + self.nitrogeno + self.metano + self.monocarbono + self.diocarbono + self.etileno + self.etano + self.acetileno
  end

  def suma_duval
    self.metano + self.etileno + self.acetileno
  end

  def metano_duval
    (self.metano.to_d/self.suma_duval)*100
  end

  def etileno_duval
    (self.etileno.to_d/self.suma_duval)*100
  end

  def acetileno_duval
    (self.acetileno.to_d/self.suma_duval)*100
  end

  #######################################################
  # CALCULO DE TIPO TRANSFORMADOR
  #######################################################
  def suma_score_peso
    if self.transformer.transformer_type_id == 1
       suma_total_peso_tipo1 = 18.0 # suma de pesos de tipo potencia
       suma_score_x_peso_tipo1 = hidrogeno_score_peso_tipo1 + metano_score_peso_tipo1 + etileno_score_peso_tipo1 + etano_score_peso_tipo1 + monocarbono_score_peso_tipo1 + diocarbono_score_peso_tipo1 + acetileno_score_peso_tipo1
       sumatoria_dgaf_tipo1 =  suma_score_x_peso_tipo1/suma_total_peso_tipo1
       return sumatoria_dgaf_tipo1
    elsif self.transformer.transformer_type_id == 2
       suma_total_peso_tipo2 = 18.0 # suma de pesos de tipo distribucion
       suma_score_x_peso_tipo2 = hidrogeno_score_peso_tipo2 + metano_score_peso_tipo2 + etileno_score_peso_tipo2 + etano_score_peso_tipo2 + monocarbono_score_peso_tipo2 + diocarbono_score_peso_tipo2 + acetileno_score_peso_tipo2
       sumatoria_dgaf_tipo2 =  suma_score_x_peso_tipo2/suma_total_peso_tipo2
       return sumatoria_dgaf_tipo2
    elsif self.transformer.transformer_type_id == 3
      return hidrogeno_score_peso_tipo3 
    end
  end

  def dgaf_condition
    if suma_score_peso < 1.2
      return "<i class='fa fa-circle fa-fw text-green me-2 fs-8px'></i>".html_safe + "Bueno".to_s #+ suma_score_peso.to_s 
    elsif suma_score_peso >= 1.2 && suma_score_peso < 1.5
      return "<i class='fa fa-circle fa-fw text-blue me-2 fs-8px'></i>".html_safe + "Aceptable".to_s
    elsif suma_score_peso >= 1.5 && suma_score_peso < 2
      return "<i class='fa fa-circle fa-fw text-yellow me-2 fs-8px'></i>".html_safe + "Necesita Revisión".to_s
    elsif suma_score_peso >= 2 && suma_score_peso < 3
      return "<i class='fa fa-circle fa-fw text-brown me-2 fs-8px'></i>".html_safe + "Malo".to_s
    elsif suma_score_peso >= 3
      return "<i class='fa fa-circle fa-fw text-red me-2 fs-8px'></i>".html_safe + "Muy Malo".to_s
    end
      
  end

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE POTENCIA
  #######################################################
  def hidrogeno_score_peso_tipo1
    if self.hidrogeno <= 150
      @scoregas = 1 # Score = 1
    elsif self.hidrogeno > 150 && self.hidrogeno <= 200 
      @scoregas = 2 # Score = 2
    elsif self.hidrogeno > 200 && self.hidrogeno <= 300
      @scoregas = 3 # Score = 3
    elsif self.hidrogeno > 300 && self.hidrogeno <= 500
      @scoregas = 4 # Score = 4
    elsif self.hidrogeno > 500 && self.hidrogeno <= 700
      @scoregas = 5 # Score = 5
    elsif self.hidrogeno > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo1
    if self.metano <= 130 
      @scoregas = 1 # Score = 1
    elsif self.metano > 130 && self.metano <= 150 
      @scoregas = 2 # Score = 2
    elsif self.metano > 150 && self.metano <= 200
      @scoregas = 3 # Score = 3
    elsif self.metano > 200 && self.metano <= 400
      @scoregas = 4 # Score = 4
    elsif self.metano > 400 && self.metano <= 600
      @scoregas = 5 # Score = 5
    elsif self.metano > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo1
    if self.etileno <= 280
      @scoregas = 1 # Score = 1
    elsif self.etileno > 280 && self.etileno <= 350 
      @scoregas = 2 # Score = 2
    elsif self.etileno > 350 && self.etileno <= 400
      @scoregas = 3 # Score = 3
    elsif self.etileno > 400 && self.etileno <= 450
      @scoregas = 4 # Score = 4
    elsif self.etileno > 450 && self.etileno <= 500
      @scoregas = 5 # Score = 5
    elsif self.etileno > 500
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo1
    if self.etano <= 90 
      @scoregas = 1 # Score = 1
    elsif self.etano > 90 && self.etano <= 110 
      @scoregas = 2 # Score = 2
    elsif self.etano > 110 && self.etano <= 150
      @scoregas = 3 # Score = 3
    elsif self.etano > 150 && self.etano <= 200
      @scoregas = 4 # Score = 4
    elsif self.etano > 200 && self.etano <= 300
      @scoregas = 5 # Score = 5
    elsif self.etano > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo1
    if self.monocarbono <= 600 
      @scoregas = 1 # Score = 1
    elsif self.monocarbono > 600 && self.monocarbono <= 700 
      @scoregas = 2 # Score = 2
    elsif self.monocarbono > 700 && self.monocarbono <= 900
      @scoregas = 3 # Score = 3
    elsif self.monocarbono > 900 && self.monocarbono <= 1100
      @scoregas = 4 # Score = 4
    elsif self.monocarbono > 1100 && self.monocarbono <= 1400
      @scoregas = 5 # Score = 5
    elsif self.monocarbono > 1400
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo1
    if self.diocarbono <= 14000 
      @scoregas = 1 # Score = 1
    elsif self.diocarbono > 14000 && self.diocarbono <= 15000
      @scoregas = 2 # Score = 2
    elsif self.diocarbono > 15000 && self.diocarbono <= 16000
      @scoregas = 3 # Score = 3
    elsif self.diocarbono > 16000 && self.diocarbono <= 17000
      @scoregas = 4 # Score = 4
    elsif self.diocarbono > 17000 && self.diocarbono <= 18000
      @scoregas = 5 # Score = 5
    elsif self.diocarbono > 18000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo1
    if self.acetileno <= 20 
      @scoregas = 1 # Score = 1
    elsif self.acetileno > 20 && self.acetileno <= 30 
      @scoregas = 2 # Score = 2
    elsif self.acetileno > 30 && self.acetileno <= 40
      @scoregas = 3 # Score = 3
    elsif self.acetileno > 40 && self.acetileno <= 50
      @scoregas = 4 # Score = 4
    elsif self.acetileno > 50 && self.acetileno <= 80
      @scoregas = 5 # Score = 5
    elsif self.acetileno > 80
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      

  #######################################################
  # CALCULOS DE TRANSFORMADOR DE DISTRIBUCION
  #######################################################
  def hidrogeno_score_peso_tipo2
    if self.hidrogeno <= 100
      @scoregas = 1 # Score = 1
    elsif self.hidrogeno > 100 && self.hidrogeno <= 200 
      @scoregas = 2 # Score = 2
    elsif self.hidrogeno > 200 && self.hidrogeno <= 300
      @scoregas = 3 # Score = 3
    elsif self.hidrogeno > 300 && self.hidrogeno <= 500
      @scoregas = 4 # Score = 4
    elsif self.hidrogeno > 500 && self.hidrogeno <= 700
      @scoregas = 5 # Score = 5
    elsif self.hidrogeno > 700
      @scoregas = 6 # Score = 6
    end
    @pesogas = 2 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def metano_score_peso_tipo2
    if self.metano <= 50
      @scoregas = 1 # Score = 1
    elsif self.metano > 50 && self.metano <= 75 
      @scoregas = 2 # Score = 2
    elsif self.metano > 75 && self.metano <= 100
      @scoregas = 3 # Score = 3
    elsif self.metano > 100 && self.metano <= 200
      @scoregas = 4 # Score = 4
    elsif self.metano > 200 && self.metano <= 300
      @scoregas = 5 # Score = 5
    elsif self.metano > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etileno_score_peso_tipo2
    if self.etileno <= 50
      @scoregas = 1 # Score = 1
    elsif self.etileno > 50 && self.etileno <= 75 
      @scoregas = 2 # Score = 2
    elsif self.etileno > 75 && self.etileno <= 100
      @scoregas = 3 # Score = 3
    elsif self.etileno > 100 && self.etileno <= 200
      @scoregas = 4 # Score = 4
    elsif self.etileno > 200 && self.etileno <= 300
      @scoregas = 5 # Score = 5
    elsif self.etileno > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def etano_score_peso_tipo2
    if self.etano <= 50
      @scoregas = 1 # Score = 1
    elsif self.etano > 50 && self.etano <= 75
      @scoregas = 2 # Score = 2
    elsif self.etano > 75 && self.etano <= 100
      @scoregas = 3 # Score = 3
    elsif self.etano > 100 && self.etano <= 200
      @scoregas = 4 # Score = 4
    elsif self.etano > 200 && self.etano <= 300
      @scoregas = 5 # Score = 5
    elsif self.etano > 300
      @scoregas = 6 # Score = 6
    end
    @pesogas = 3 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end

  def monocarbono_score_peso_tipo2
    if self.monocarbono <= 200
      @scoregas = 1 # Score = 1
    elsif self.monocarbono > 200 && self.monocarbono <= 300 
      @scoregas = 2 # Score = 2
    elsif self.monocarbono > 300 && self.monocarbono <= 400
      @scoregas = 3 # Score = 3
    elsif self.monocarbono > 400 && self.monocarbono <= 500
      @scoregas = 4 # Score = 4
    elsif self.monocarbono > 500 && self.monocarbono <= 600
      @scoregas = 5 # Score = 5
    elsif self.monocarbono > 600
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def diocarbono_score_peso_tipo2
    if self.diocarbono <= 5000 
      @scoregas = 1 # Score = 1
    elsif self.diocarbono > 5000 && self.diocarbono <= 6000
      @scoregas = 2 # Score = 2
    elsif self.diocarbono > 6000 && self.diocarbono <= 7000
      @scoregas = 3 # Score = 3
    elsif self.diocarbono > 7000 && self.diocarbono <= 8000
      @scoregas = 4 # Score = 4
    elsif self.diocarbono > 8000 && self.diocarbono <= 9000
      @scoregas = 5 # Score = 5
    elsif self.diocarbono > 18000
      @scoregas = 6 # Score = 6
    end
    @pesogas = 1 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end  

  def acetileno_score_peso_tipo2
    if self.acetileno <= 5
      @scoregas = 1 # Score = 1
    elsif self.acetileno > 5 && self.acetileno <= 7
      @scoregas = 2 # Score = 2
    elsif self.acetileno > 7 && self.acetileno <= 10
      @scoregas = 3 # Score = 3
    elsif self.acetileno > 10 && self.acetileno <= 20
      @scoregas = 4 # Score = 4
    elsif self.acetileno > 20 && self.acetileno <= 30
      @scoregas = 5 # Score = 5
    elsif self.acetileno > 30
      @scoregas = 6 # Score = 6
    end
    @pesogas = 5 # Peso Gas                                       
    @dgagas = @scoregas * @pesogas
    return @dgagas  # Resultado Score X Peso
  end      
  #######################################################

  private
    def save_default_values
      self.deleted = 0    
    end 
end 