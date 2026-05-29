class Bornal < ApplicationRecord
  # Model relationships
  belongs_to :transformer
 
   # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
    validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."

  def dgaf_condition
    if self.num_fac < 0.5
      return "<i class='fa fa-circle fa-fw text-green me-2 fs-8px'></i>".html_safe + "Condición: Muy Bueno".to_s #+ suma_score_peso.to_s 
    elsif self.num_fac >= 0.5 && self.num_fac < 0.7
      return "<i class='fa fa-circle fa-fw text-blue me-2 fs-8px'></i>".html_safe + "Condición: Bueno".to_s
    elsif self.num_fac >= 0.7 && self.num_fac < 1
      return "<i class='fa fa-circle fa-fw text-yellow me-2 fs-8px'></i>".html_safe + "Condición: Medio".to_s
    elsif self.num_fac >= 1 && self.num_fac < 2
      return "<i class='fa fa-circle fa-fw text-brown me-2 fs-8px'></i>".html_safe + "Condición: Pobre".to_s
    elsif self.num_fac >= 2
      return "<i class='fa fa-circle fa-fw text-red me-2 fs-8px'></i>".html_safe + "Condición: Muy Pobre".to_s
    end
  end

  # Method string on action show
  def str_date_rehearsal
    self.date_rehearsal.strftime("%d/%m/%Y")
  end
 

  # RANSACKER
  ransacker :date_rehearsal do
    Arel.sql('strftime("%Y",date_rehearsal)')
  #  strftime('%Y',date_rehearsal)    SQLITE3
  #  YEAR(date_rehearsal)             MYSQL
  end

  # Pagination = 10
  self.per_page = 10

  private
    def save_default_values
      self.deleted = 0    
    end 
end 
