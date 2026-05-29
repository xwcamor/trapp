class Audit < ApplicationRecord
  # Model relationships
  belongs_to :user
 
  serialize :audited_changes
  

  # Actions using private
  #before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y %H:%M:%S")
  end

  # Method string on action show
  def str_created_at_table
    self.created_at.strftime("%Y%m%d")
  end



  # Method string on action show
#   def str_action
#    @deleted ="---
# deleted:
# - 0
# - 1
# "
#     if  self.audited_changes == @deleted
#      return "Eliminó Data"
#     else
#       if  self.action == "update"
#         return "Actualizó Data" 
#       else
#         return "Creó Data"
#       end
#     end

   
#   end

  def str_action
    @deleted ='{"deleted"=>[0, 1]}'
    if  self.audited_changes.to_s == @deleted
     return "Eliminó Data"
    else
      if  self.action == "update"
        return "Actualizó Data" 
      else
        return "Creó Data"
      end
    end
  end


  # Method string on action show
  def str_auditable_type
    return "Usuarios"            if auditable_type == "User"    
    return "Clientes"            if auditable_type == "Customer"
    return "Ubicaciones"         if auditable_type == "CustomerLocation"
    return "Áreas"               if auditable_type == "CustomerArea"
    return "Subestaciones"       if auditable_type == "CustomerSubstation"
    return "Transformadores"     if auditable_type == "Transformer"
    return "Cromatografía"       if auditable_type == "Chromatographical"
    return "Físico Químico"      if auditable_type == "Physical"
    return "Furanos"             if auditable_type == "Furano"
    return "Factor de Potencia"  if auditable_type == "Factor"
    return "Devanados"           if auditable_type == "Devanado"
    return "Devanado Detalles "  if auditable_type == "DevanadoDetail"    
  end  

  # Method string on action show
  def str_auditable_type_details
    if auditable_type == "User"
      user = User.find(self.auditable_id)
      return "Usuario: " + user.str_complete_name    
    elsif auditable_type == "Customer"
      customer = Customer.find(self.auditable_id)
      return "Cliente: " + customer.name
    elsif auditable_type == "CustomerLocation"
      customer = Customer.find(self.associated_id)
      customer_location = CustomerLocation.find(self.auditable_id)
      return "Cliente: "+ customer.name.to_s  + "\n\n"  +"Ubicación: ".to_s + customer_location.name.to_s
    elsif auditable_type == "CustomerArea"
      customer = Customer.find(self.associated_id)
      customer_area = CustomerArea.find(self.auditable_id)
      return "Cliente: "+ customer.name.to_s  + "\n\n"  +"Área: ".to_s + customer_area.name.to_s
    elsif auditable_type == "CustomerSubstation"
      customer = Customer.find(self.associated_id)
      customer_substation = CustomerSubstation.find(self.auditable_id)
      return "Cliente: "+ customer.name.to_s  + "\n\n"  +"Subestación: ".to_s + customer_substation.name.to_s            
    elsif auditable_type == "Transformer"
      transformer = Transformer.find(self.auditable_id)
      return "Transformador: " + transformer.num_serie      
    elsif auditable_type == "Chromatographical"
      transformer = Transformer.find(self.associated_id)
      chromatographical = Chromatographical.find(self.auditable_id)
      return "Transformador: \n\n"+ transformer.num_serie  + "\n\n"  +"Cromatografía: \n\n".to_s + chromatographical.str_date_rehearsal                  
    elsif auditable_type == "Physical"
      transformer = Transformer.find(self.associated_id)
      physical = Physical.find(self.auditable_id)
      return "Transformador: \n\n"+ transformer.num_serie  + "\n\n"  +"Físico Químico: \n\n".to_s + physical.str_date_rehearsal                        
    elsif auditable_type == "Furano"
      transformer = Transformer.find(self.associated_id)
      furano = Furano.find(self.auditable_id)
      return "Transformador: \n\n"+ transformer.num_serie  + "\n\n"  +"Furanos: \n\n".to_s + furano.str_date_rehearsal                        
    elsif auditable_type == "Factor"
      transformer = Transformer.find(self.associated_id)
      factor = Factor.find(self.auditable_id)
      return "Transformador: \n\n"+ transformer.num_serie  + "\n\n"  +"Factor de Potencia: \n\n".to_s + factor.str_date_rehearsal                              
    elsif auditable_type == "Devanado"
      transformer = Transformer.find(self.associated_id)
      devanado = Devanado.find(self.auditable_id)
      return "Transformador: \n\n"+ transformer.num_serie  + "\n\n"  +"Devanados: \n\n".to_s + devanado.str_date_rehearsal                              
    elsif auditable_type == "DevanadoDetail"
      #transformer = Transformer.find(self.associated_id)
      devanado = Devanado.find(self.associated_id)
      devanado_detail = DevanadoDetail.find(self.auditable_id)
      return  "Devanados: \n\n".to_s + devanado.str_date_rehearsal                                    
    end  
  end  

  private
    def save_default_values
      self.deleted = 0    
    end 
end 