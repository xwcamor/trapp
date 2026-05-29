class TransformerManagement::ImportTransformersController < ApplicationController
  before_action :authenticate_user
 
  

  def step1
    if user_permission.include?(159)
      @customers = Customer.where("deleted=0 ").order("name ASC")
        
      @query = Customer.ransack(params[:q])
      @query.deleted_eq = 0
      @list_array = @query.result

      @job_remove = ImportTransformer.delete_by(user_id: current_user.id)
 
      #redirect_on_back_to "/im_management/import_transformers/step1" # Prevent to use back to create
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  def step2
    if user_permission.include?(159)
      if params[:search_customer].present?      
        @search_customer = params[:search_customer]
        @customer = Customer.find(@search_customer)

        @query = ImportTransformer.ransack(params[:q])
        @query.was_upload_eq = 0

        @list_array = @query.result
        @transformer = ImportTransformer.new
        
        @job_remove = ImportTransformer.delete_by(user_id: current_user.id)
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
    if user_permission.include?(159)
      if params[:search_customer].present?
        user_id = current_user.id
        customer_id = params[:search_customer] 
        ImportTransformer.import( params[:file], customer_id, user_id )    
 
        check_file = ImportTransformer.select("file_id").where("user_id = ? AND customer_id = ?",user_id, customer_id).last
        file_num = check_file.try(:file_id).to_i 

        #redirect_to step3_im_management_import_transformers_path(customer_id: params[:search_customer], user_id: user_id, file_id: file_num )
        redirect_to "/transformer_management/import_transformers/step3?customer_id=#{customer_id}&user_id=#{user_id}"
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
    if user_permission.include?(159)
      if params[:customer_id].present?
        @customer = Customer.find(params[:customer_id])
        @list_array = ImportTransformer.distinct(:num_serie).where("deleted=0 AND num_serie NOT IN (select num_serie from transformers where deleted=0)")

       

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
    if user_permission.include?(159)
      if params[:customer_id].present?
        #@import_transformers = ImportTransformer.distinct(:num_serie).where("deleted=0 AND num_serie NOT IN (select num_serie from transformers where deleted=0)")
        @transformers = Transformer.where("deleted=0")
        user_id = current_user.id
        customer_id = params[:customer_id] 
        @customer = Customer.find(customer_id)
     

        @query = ImportTransformer.ransack(params[:q])
        @query.was_upload_eq = 0
        @query.deleted_eq = 0
        @query.customer_id_eq = customer_id
        @query.user_id_eq = current_user.id
        @query.num_serie_not_in = @transformers.pluck(:num_serie)

        @list_array = @query.result 
        
        @errors = [] 
        @list_array.each do |array|
          @mark = Mark.find_by(deleted: 0, name: array.mark_name)
          @oil_type = OilType.find_by(deleted: 0, name: array.oil_type_name) 
          @transformer_type = TransformerType.find_by(deleted: 0, name: array.transformer_type_name)
          @conmutation_type = ConmutationType.find_by(deleted: 0, name: array.conmutation_type_name)
          @transformer_preservation = TransformerPreservation.find_by(deleted: 0, name: array.transformer_preservation_name)
          @customer_substation = CustomerSubstation.find_by(deleted: 0, name: array.customer_substation_name, customer_id: customer_id ) 

          transformer = Transformer.new
          transformer.customer_substation_id = @customer_substation.id
          transformer.num_serie = array.num_serie.delete(" \t\r\n")
          transformer.num_tag = array.num_tag 
          transformer.num_vol = array.num_vol
          transformer.num_pot = array.num_pot 
          transformer.age = array.age 
          transformer.mark_id =  @mark.id
          transformer.oil_type_id = @oil_type.id
          transformer.transformer_type_id = @transformer_type.id
          transformer.conmutation_type_id = @conmutation_type.id
          transformer.transformer_preservation_id = @transformer_preservation.id 
          transformer.connection_type_id = 16 #OTROS
          transformer.num_health = 0
          transformer.state_health = "Muy Malo"
          transformer.color_health = "red"
          transformer.num_fas = array.num_fas 
          transformer.save

          if transformer.save
            # stuff to do on successful save 
          else
            transformer.errors.full_messages.each do |message|
              @errors << "<strong>La Serie: #{transformer.num_serie} con el Tag: #{transformer.num_tag} ya existe.</strong>".html_safe
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