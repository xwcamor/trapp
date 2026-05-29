class Factor < ApplicationRecord
  # Model relationships
  belongs_to :transformer
 
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Audit
  audited associated_with: :transformer

  # Validate
  validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El CHROMOregistro se encuentra en uso."

  def dgaf_condition
    if self.num_fac < 0.5
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Muy Bueno".to_s 
    elsif self.num_fac >= 0.5 && self.num_fac < 0.7
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Bueno".to_s
    elsif self.num_fac >= 0.7 && self.num_fac < 1
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe + "Medio".to_s
    elsif self.num_fac >= 1 && self.num_fac < 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Malo".to_s
    elsif self.num_fac >= 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Muy Malo".to_s
    end
  end

  def dgaf_score
    if self.num_fac < 0.5
      return 20
    elsif self.num_fac >= 0.5 && self.num_fac < 0.7
      return 15
    elsif self.num_fac >= 0.7 && self.num_fac < 1
      return 10
    elsif self.num_fac >= 1 && self.num_fac < 2
      return 5
    elsif self.num_fac >= 2
      return 0
    end
  end


  def dgaf_condition_circle
    if self.num_fac < 0.5
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe
    elsif self.num_fac >= 0.5 && self.num_fac < 0.7
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe
    elsif self.num_fac >= 0.7 && self.num_fac < 1
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe
    elsif self.num_fac >= 1 && self.num_fac < 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe
    elsif self.num_fac >= 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe
    end
  end

  # Method string on action show
  def str_date_rehearsal
    self.date_rehearsal.strftime("%d-%m-%Y")
  end
 
  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y")
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
