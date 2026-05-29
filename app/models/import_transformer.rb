class ImportTransformer < ActiveRecord::Base
  # Model relationships	
 # belongs_to :transformer_test


  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."


  ##########################################
  def self.import(file, customer_id, user_id)
    @errors = []
    @check_file = ImportTransformer.select("file_id").all.last
    @file_num = @check_file.try(:file_id).to_i + 1

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
      column11 =spreadsheet.cell(i,'K')
      column12 =spreadsheet.cell(i,'K')

      transformer = ImportTransformer.new( :customer_id => customer_id, :user_id => user_id, :file_id => @file_num,
      :customer_substation_name    => column1.to_s,          
                      :num_serie   => column2.to_s,
                      :num_tag     => column3.to_s,
                      :num_vol     => column4.to_s,
                      :num_pot     => column5.to_s,
                      :mark_name   => column6.to_s,
                      :age         => column7,
                 :oil_type_name    => column8.to_s,
         :transformer_type_name    => column9.to_s,
         :connection_type_name     => "Otros",
         :conmutation_type_name    => column10.to_s,
 :transformer_preservation_name    => column11.to_s,
                       :num_fas    => column12.to_i,
          
      )
      if transformer.save
        # stuff to do on successful save 
      else
        transformer.errors.full_messages.each do |message|
          @errors << "La información de la línea #{i}, <strong>columna #{message}</strong>".html_safe
        end
      end
            
    end  
    @errors #  <- need to return the @errors array     
  end

  ########################################

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then  Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then  Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    else raise "Tipo de archivo desconocido: #{file.original_filename}"
    end
  end


 
  private
    def save_default_values
      self.deleted = 0    
      self.was_upload = 0    
    end   
end