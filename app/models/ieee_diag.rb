class IeeeDiag < ApplicationRecord
  # Model relationships
  belongs_to :transformer
  has_many :ieee_diag_details
  
   # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."

  # Method string on action show
  def str_state
    return "Activo" if state == 0
    return "Inactivo" if state == 1
  end

  # Method string on action show
  def str_date_rehearsal
    self.date_rehearsal.strftime("%d-%m-%Y")
  end

  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y")
  end

  #######################################################
  # LIMITES DE GASES EN TRANSFORMADOR NOMA IEEE (TABLA 4)
  #######################################################

  def ieee_hidrogeno_tabla4
    @condition = self.ratio
    @period = self.month_period

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
    @condition = self.ratio
    @period = self.month_period

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
    @condition = self.ratio
    @period = self.month_period

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
    @condition = self.ratio
    @period = self.month_period

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
    @condition = self.ratio
    @period = self.month_period

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
    @condition = self.ratio
    @period = self.month_period

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

  #######################################################
  # EVALUACION DE TABLA 4 EN TRANSFORMADOR NOMA IEEE
  #######################################################
   
  def ieee_hidrogeno_tabla4_eva
    @limit = self.ieee_hidrogeno_tabla4.to_f

    if self.ppm_hid >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_metano_tabla4_eva
    @limit = self.ieee_metano_tabla4.to_f

    if self.ppm_met >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_etano_tabla4_eva
    @limit = self.ieee_etano_tabla4.to_f

    if self.ppm_eta >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_etileno_tabla4_eva
    @limit = self.ieee_etileno_tabla4.to_f

    if self.ppm_eti >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_acetileno_tabla4_eva
    @limit = self.ieee_acetileno_tabla4.to_f

    if self.ppm_ace >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_monocarbono_tabla4_eva
    @limit = self.ieee_monocarbono_tabla4.to_f

    if self.ppm_mon >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end

  def ieee_diocarbono_tabla4_eva
    @limit = self.ieee_diocarbono_tabla4.to_f

    if self.ppm_dio >= @limit
      @eva1tabla4 = "no"
    else
      @eva1tabla4 = "si"
    end

    return @eva1tabla4
  end



  # Pagination = 10
  self.per_page = 10
 
  private
    def save_default_values
      self.date_rehearsal = Time.now
      self.state = 1  
      self.deleted = 2
    end 
end 
