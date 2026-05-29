class GasKey < ApplicationRecord
  # Model relationships
  belongs_to :transformer


  def str_gas_key

  	if    self.state == 1 && self.transformer.oil_type_id.to_i == 4
      return "Sobrecalentamiento de Silicona" 
    elsif self.state == 2 && self.transformer.oil_type_id.to_i == 4
      return "Sobrecalentamiento de Celulosa en Fluido de Silicona"
    elsif self.state == 3 && self.transformer.oil_type_id.to_i == 4  
      return "Corona en Silicona"  
    elsif self.state == 4 && self.transformer.oil_type_id.to_i == 4  
      return "Arco en Silicona"   
  	elsif self.state == 1 && self.transformer.oil_type_id.to_i == 1
      return "Sobrecalentamiento de Aceite" 
    elsif self.state == 2 && self.transformer.oil_type_id.to_i == 1
      return "Sobrecalentamiento de Celulosa"
    elsif self.state == 3 && self.transformer.oil_type_id.to_i == 1  
      return "Corona en Aceite"  
    elsif self.state == 4 && self.transformer.oil_type_id.to_i == 1  
      return "Arco en Aceite"  
    end   

  end
  
end 