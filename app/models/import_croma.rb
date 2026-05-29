class ImportCroma < ActiveRecord::Base
  # Model relationships	
 # belongs_to :transformer_test


  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."


  ##########################################
  def self.import(file, customer_id, user_id)
    @errors = []
    @check_file = ImportCroma.select("file_id").all.last
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


      cromatographical = ImportCroma.new( :customer_id => customer_id, :user_id => user_id, :file_id => @file_num,
                      :num_serie   => column1.to_s,
                :date_rehearsal    => column2.to_s,          
                      :num_hid     => column3.to_s,
                      :num_oxi     => column4.to_s,
                      :num_nit     => column5.to_s,
                      :num_met     => column6.to_s,
                      :num_mon     => column7.to_s,
                      :num_dio     => column8.to_s,
                      :num_eti     => column9.to_s, 
                      :num_eta     => column10.to_s,
                      :num_ace     => column11.to_s 
         
          
      )
      if cromatographical.save
        # stuff to do on successful save 
      else
        cromatographical.errors.full_messages.each do |message|
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