class ChromatographicalDuval < ApplicationRecord
  # Model relationships
  belongs_to :transformer
  after_update :update_triangle_pentagon_diag_first
   
  def str_triangle_diag_first
  	if    self.triangle_diag_first == "PD"
  	  return "PD = Descarga Parcial" 
    elsif self.triangle_diag_first == "T1"
      return "T1 = Falla Térmica; Temp <300℃"  
    elsif self.triangle_diag_first == "T2"
      return  "T2 = Falla Térmica; Temp > 300℃ & < 700℃"
    elsif self.triangle_diag_first == "T3"
      return  "T3 = Falla Térmica; Temp > 700℃"
    elsif self.triangle_diag_first == "D1"
      return  "D1 = Descarga de Baja Energía"
    elsif self.triangle_diag_first == "D2"
      return  "D2 = Descarga de Alta Energía"
    elsif self.triangle_diag_first == "DT"
      return  "DT = Eléctrico y Térmico"                        
    end
  end
  
  def str_pentagon_diag_first
  	if    self.pentagon_diag_first == "PD"
  	  return "PD = Descarga Parcial." 
    elsif self.pentagon_diag_first == "S"
      return "S = Pérdida de Gas de aceite mineral; Temp < 200℃" 
    elsif self.pentagon_diag_first == "T1-O"
     return "T1-O = Fallas de baja temperatura sin carbonización del papel." 
    elsif self.pentagon_diag_first == "T1-C"
     return "T1-C = Fallas de baja temperatura con probable carbonización del papel." 
    elsif self.pentagon_diag_first == "T2-C"
     return "T2-C = Fallas de temperatura media con probable carbonización del papel." 
    elsif self.pentagon_diag_first == "T2-O"
      return "T2-O = Fallas de temperatura media sin carbonización del papel." 
    elsif self.pentagon_diag_first == "T3-C"
     return "T3-C = Fallas de alta temperatura con probable carbonización del papel."           
    elsif self.pentagon_diag_first == "T3-H"
     return "T3-H = Fallas de alta temperatura sin carbonización del papel."           
    elsif self.pentagon_diag_first == "D1"
     return "D1 = Descarga Eléctrica de Baja Energía"           
    elsif self.pentagon_diag_first == "D2"
     return "D2 = Descarga Eléctrica de Alta Energía."                          
    end  	
  end

  # Validate 
  private
    def save_default_values
      self.deleted = 0    
    end 

    def update_triangle_pentagon_diag_first
      if self.triangle_diag_first.nil? or self.triangle_diag_first.blank?
        duval_transformer = ChromatographicalDuval.where("transformer_id = ?",self.transformer_id).update_all(triangle_diag_first: "PD" )
      end

      if self.pentagon_diag_first.nil? or self.pentagon_diag_first.blank?
        duval_transformer = ChromatographicalDuval.where("transformer_id = ?",self.transformer_id).update_all(pentagon_diag_first: "PD" )
      end            
 
    end
 

end 
