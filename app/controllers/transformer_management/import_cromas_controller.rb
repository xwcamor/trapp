class TransformerManagement::ImportCromasController < ApplicationController
  before_action :authenticate_user
 
  

  def step1
    if user_permission.include?(160)
      @customers = Customer.where("deleted=0 ").order("name ASC")
        
      @query = Customer.ransack(params[:q])
      @query.deleted_eq = 0
      @list_array = @query.result

      #@job_remove = ImportCroma.where("user_id = ?",current_user.id).destroy_all
      @job_remove = ImportCroma.delete_by(user_id: current_user.id)
 
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  def step2
    if user_permission.include?(160)
      if params[:search_customer].present?      
        @search_customer = params[:search_customer]
        @customer = Customer.find(@search_customer)

        @query = ImportCroma.ransack(params[:q])
        @query.was_upload_eq = 0

        @list_array = @query.result
        @transformer = ImportCroma.new
        
        @job_remove = ImportCroma.delete_by(user_id: current_user.id)
      else
        #redirect_back(fallback_location: step1_im_management_import_transformers_url) 
      end
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end     	
  end  

  def step2s
    if user_permission.include?(160)
      if params[:search_customer].present?
        user_id = current_user.id
        customer_id = params[:search_customer] 
        ImportCroma.import( params[:file], customer_id, user_id )    
 
        check_file = ImportCroma.select("file_id").where("user_id = ? AND customer_id = ?",user_id, customer_id).last
        file_num = check_file.try(:file_id).to_i 

        #redirect_to step3_im_management_import_transformers_path(customer_id: params[:search_customer], user_id: user_id, file_id: file_num )
        redirect_to "/transformer_management/import_cromas/step3?customer_id=#{customer_id}&user_id=#{user_id}"
      else
        #redirect_back(fallback_location: step1_im_management_import_transformers_url) 
      end
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end       
  end  


  def step3
    if user_permission.include?(160)
      if params[:customer_id].present?
        @customer = Customer.find(params[:customer_id])
        #@list_array = ImportCroma.distinct(:num_serie).where("deleted=0 AND num_serie NOT IN (select num_serie from transformers where deleted=0)")
        @list_array = ImportCroma.where("deleted=0")

       

        #redirect_to step3_im_management_import_transformers_path(customer_id: params[:search_customer], user_id: user_id, file_id: file_num )
        #redirect_to "/im_management/import_transformers/step3?customer_id=#{customer_id}&user_id=#{user_id}"
      else
        #redirect_back(fallback_location: step1_im_management_import_transformers_url) 
      end
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end       
  end  

  def step4
    if user_permission.include?(160)
      if params[:customer_id].present?
        #@import_transformers = ImportTransformer.distinct(:num_serie).where("deleted=0 AND num_serie NOT IN (select num_serie from transformers where deleted=0)")
        @transformers = Transformer.where("deleted=0")
        user_id = current_user.id
        customer_id = params[:customer_id] 
        @customer = Customer.find(customer_id)
     

        @query = ImportCroma.ransack(params[:q])
        @query.was_upload_eq = 0
        @query.deleted_eq = 0
        @query.customer_id_eq = customer_id
        @query.user_id_eq = current_user.id

        @list_array = @query.result 
        
        @errors = [] 
        @list_array.each do |array|
          @transformer = Transformer.find_by(deleted: 0, num_serie: array.num_serie.delete(" \t\r\n"))
 
          cromatographical = Chromatographical.new
          cromatographical.transformer_id = @transformer.id
          cromatographical.date_rehearsal = array.date_rehearsal 
          cromatographical.num_hid = array.num_hid 
          cromatographical.num_oxi = array.num_oxi 
          cromatographical.num_nit = array.num_nit 
          cromatographical.num_met = array.num_met 
          cromatographical.num_mon = array.num_mon 
          cromatographical.num_dio = array.num_dio 
          cromatographical.num_eti = array.num_eti 
          cromatographical.num_eta = array.num_eta 
          cromatographical.num_ace = array.num_ace 
          cromatographical.deleted = 0
 
          cromatographical.save

          if cromatographical.save
            # stuff to do on successful save 
          else
            cromatographical.errors.full_messages.each do |message|
              @errors << "<strong>La Serie: #{cromatographical.transformer_id} con el Tag: #{cromatographical.date_rehearsal} ya existe.</strong>".html_safe
            end
          end
        end
        #redirect_to "/im_management/import_transformers/steps_done"

       

        #redirect_to step3_im_management_import_transformers_path(customer_id: params[:search_customer], user_id: user_id, file_id: file_num )
        #redirect_to "/im_management/import_transformers/step3?customer_id=#{customer_id}&user_id=#{user_id}"
      else
        #redirect_back(fallback_location: step1_im_management_import_transformers_url) 
      end
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end       
  end  

end