class Furano < ApplicationRecord
  # Model relationships
  belongs_to :transformer
 
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Audit
  audited associated_with: :transformer

  # Validate
  validates_presence_of   :date_rehearsal, message: 'No puede estar en blanco o vacío.' 
  validates_uniqueness_of :date_rehearsal, :scope => [:transformer_id], conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "La Fecha ya existe."
  validates_presence_of :num_fal, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_hme, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_ace, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_mfu, message: 'No puede estar en blanco o vacío.' 
  validates_presence_of :num_fua, message: 'No puede estar en blanco o vacío.' 


  def dgaf_condition
    if self.num_fal < 0.5
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>"></i>'.html_safe + "Muy Bueno".to_s 
    elsif self.num_fal >= 0.5 && self.num_fal < 0.7
      return '<i class="fa fa-circle fa-fw text-green me-2 fs-10px"></i>'.html_safe + "Bueno".to_s
    elsif self.num_fal >= 0.7 && self.num_fal < 1
      return '<i class="fa fa-circle fa-fw text-yellow me-2 fs-10px"></i>'.html_safe + "Medio".to_s
    elsif self.num_fal >= 1 && self.num_fal < 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Malo".to_s
    elsif self.num_fal >= 2
      return '<i class="fa fa-circle fa-fw text-red me-2 fs-10px"></i>'.html_safe + "Muy Malo".to_s
    end
  end


  def dgaf_score
    @furano = self.num_fal.to_f/1000
    if @furano >= 0 && @furano < 0.1
      return 20
    elsif @furano >= 0.1 && @furano < 0.25
      return 15
    elsif @furano >= 0.25 && @furano < 0.5
      return 10
    elsif @furano >= 0.5 && @furano < 1.0
      return 5
    elsif @furano >= 1
      return 0
    end
  end


  def dgaf_score_ratio
    @furano = self.num_fal.to_f/1000
    if @furano >= 0 && @furano < 0.1
      return 4
    elsif @furano >= 0.1 && @furano < 0.25
      return 3
    elsif @furano >= 0.25 && @furano < 0.5
      return 2
    elsif @furano >= 0.5 && @furano < 1.0
      return 1
    elsif @furano >= 1
      return 0
    end
  end

  def shendong
    @fal_ppm = self.num_fal.to_f/1000
    @log_fal = Math::log10(@fal_ppm) 
    @shen_numerator =   1.51 - @log_fal
    @shen_denominator = 0.0035
    @result = @shen_numerator /  @shen_denominator
    return @result.round(2)
  end

  # Method string on action show
  def str_date_rehearsal
    if self.transformer.has_special_testing_fur == 0
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
  #self.per_page = 10

  # Modulo de Importación 
  def self.import(file, transformer_id)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)

    expected_headers = [
      'Fecha(dd/mm/aaaa)','2-Furfuraldehido (FAL ppb)', '5-Hidroximetil-2Furfural (5HMF ppb)',
      '2-Furil-metil-cetona (ACF ppb)', '5-metil-2-furfuraldehido (MEF ppb)','2-Furilalcohol (FOL ppb)'
    ]


    unless header == expected_headers
      raise "Formato Excel inválido.<br>Las columnas deben tener los siguientes nombres:<br> #{expected_headers.join(', ')}"
    end

    errors = []
    (2..spreadsheet.last_row).each do |i|
      furano = new
      furano.date_rehearsal = Date.strptime(spreadsheet.cell(i, 'A'), '%d/%m/%Y') rescue nil
      furano.num_fal = spreadsheet.cell(i, 'B')
      furano.num_hme = spreadsheet.cell(i, 'C')
      furano.num_ace = spreadsheet.cell(i, 'D')
      furano.num_mfu = spreadsheet.cell(i, 'E')
      furano.num_fua = spreadsheet.cell(i, 'F')
      furano.transformer_id = transformer_id
      furano.deleted = 0

      unless furano.save
        errors << "<br>Error en Línea #{i}: #{furano.errors.full_messages.join(', ')}"
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
 
      furano = Furano.new(
       :date_rehearsal => column1, :num_fal => column2,
       :num_hme => column3, :num_ace => column4,
       :num_mfu => column5, :num_fua => column6,
       :transformer_id => transformer_id,:deleted=> 0 )
      if furano.save
        # stuff to do on successful save 
      else
        furano.errors.full_messages.each do |message|
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
end 
