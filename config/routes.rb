Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :audit_management do
    resources :audits
    resources :admin_audits
  end
  # Calendar Management routes 
  namespace :calendar_management do
    resources :course_recurring_events
    resources :course_events
    resources :meet_events
    resources :meet_schedules  
  end
  #resources :events

  namespace :json_management do
    resources :transformers
    resources :transformer_ratios    
    resources :dashboard_users  
    resources :audits   
    resources :admin_audits  
    
    # laboratorio CONNECTION
    namespace :lab_registries do
      resources :transformers   do
          match 'step1', :via => [ :get] , :on => :collection
          match 'search', :via => [ :get] , :on => :collection
          match 'update_div', :via => [ :get] , :on => :collection
      end
    end  

  end

  # Comparison Management routes 
  namespace :comparison_management do
    resources :chromatographicals do
      match 'search', :via => [:post,:get], :on => :collection
      match 'step1', :via => [ :get] , :on => :collection
      match 'step2', :via => [:post ], :on => :collection
    end   

    resources :gases do
      match 'search', :via => [:post,:get], :on => :collection
      match 'step1', :via => [ :get] , :on => :collection
      match 'step2', :via => [:post ], :on => :collection
    end      
  end

  # Notification Management routes 
  namespace :notification_management do
    resources :admin_user_notifications do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :user_notifications do
      match 'search', :via => [:post,:get], :on => :collection
    end      
  end

  # Notification Management routes 
  namespace :meeting_management do
    resources :admin_meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :admin_calendar_meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end 

    resources :meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end      
    resources :calendar_meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :view_meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end           
    resources :user_meetings do
      match 'search', :via => [:post,:get], :on => :collection
    end     
  end

  # Report Management routes 
  namespace :report_management do
 

    resources :reports do
      match 'search', :via => [:post, :get], :on => :collection
      match 'delete', :via => [:get]
      match 'upload_customer_file', :via => [:get]

      member do
        get :export_combined_pdf
      end
    end


    resources :admin_reports do
      match 'search', :via => [:post,:get], :on => :collection
    end  

    resources :transformer_reports do
      match 'search', :via => [:post,:get], :on => :collection
    end  

    resources :step1_reports do
      match 'search', :via => [:post,:get], :on => :collection
    end    
    resources :step2_reports do
      match 'search', :via => [:post,:get], :on => :collection
    end          
    resources :customers do
      match 'search', :via => [:post,:get], :on => :collection
      resources :step1_reports do
        match 'search', :via => [:post,:get], :on => :collection
      end    
      resources :step2_reports do
        match 'search', :via => [:post,:get], :on => :collection
      end  
    end   
  end

  # Mark Management routes 
  namespace :mark_management do
    resources :marks do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Graph Management routes 
  namespace :graph_management do
    resources :transformer_graphs do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Oil Type Management routes 
  namespace :oil_type_management do
    resources :oil_types do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Connection Type Management routes 
  namespace :connection_type_management do
    resources :connection_types do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Country Management routes 
  namespace :country_management do
    resources :countries do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # User News Management routes 
  namespace :newspaper_management do
    resources :newspapers do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :admin_newspapers do
      match 'search', :via => [:post,:get], :on => :collection
    end      
  end  

  # Customer Management routes 
  namespace :customer_management do
    resources :customers do
      match 'delete', :via => [:get]
      match 'search', :via => [:post,:get], :on => :collection
 
      resources :customer_locations do
        match 'search', :via => [:post,:get], :on => :collection
        match 'delete', :via => [:get]
      end       
      resources :customer_substations do
        match 'search', :via => [:post,:get], :on => :collection
        match 'delete', :via => [:get]
      end   
      resources :customer_areas do
        match 'search', :via => [:post,:get], :on => :collection
        match 'delete', :via => [:get]
      end         
      resources :data_customers do
        match 'search', :via => [:post,:get], :on => :collection
      end  
      
    end   
    resources :customer_locations do
      match 'search', :via => [:post,:get], :on => :collection
    end       
    resources :customer_substations do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :customer_areas do
      match 'search', :via => [:post,:get], :on => :collection
    end         
    resources :data_customers do
      match 'search', :via => [:post,:get], :on => :collection
    end           
    resources :user_customers do
      match 'search', :via => [:post,:get], :on => :collection
    end      
    resources :user_customer_locations do
      match 'search', :via => [:post,:get], :on => :collection
    end    
    resources :user_customer_areas do
      match 'search', :via => [:post,:get], :on => :collection
    end    
    resources :user_customer_substations do
      match 'search', :via => [:post,:get], :on => :collection
    end        
    resources :user_customer_transformers do
      match 'search', :via => [:post,:get], :on => :collection
    end              
  end

  # Transformer Management routes 
  namespace :transformer_management do
    resources :transformers do
      match 'delete', :via => [:get]
      match 'edit_report', :via => [:get]
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :data_transformers do
      match 'search', :via => [:post,:get], :on => :collection
    end    

    resources :import_transformers do
      match 'step1',  :via => [:get], :on => :collection
      match 'step2',  :via => [:get,:post], :on => :collection
      match 'step2s', :via => [:get,:post], :on => :collection
      match 'step3',  :via => [:get,:post], :on => :collection
      match 'step4',  :via => [:get,:post], :on => :collection
      match 'steps_done', :via => [:get,:post], :on => :collection
    end     

    resources :import_cromas do
      match 'step1',  :via => [:get], :on => :collection
      match 'step2',  :via => [:get,:post], :on => :collection
      match 'step2s', :via => [:get,:post], :on => :collection
      match 'step3',  :via => [:get,:post], :on => :collection
      match 'step4',  :via => [:get,:post], :on => :collection
      match 'steps_done', :via => [:get,:post], :on => :collection
    end          
  end

  # Chromatographical Management routes 
  namespace :chromatographical_management do
    resources :transformer do
      resources :chromatographicals do
        match 'delete', :via => [:get]
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :table_chromatographicals do
        match 'search', :via => [:post,:get], :on => :collection
      end              
      resources :iec_graphs, :ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :report_iec_graphs, :report_ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end     
      resources :ieee_diags do
        match 'search', :via => [:post,:get], :on => :collection
      end          
      resources :posts do
        match 'search', :via => [:post,:get], :on => :collection
      end        
      resources :chromatographical_duvals
      resources :chromatographical_dga_diags     
      resources :gas_keys 
      resources :chromatographical_uploads, only: [:new, :create] do
        collection { post :import }
      end
    end   
    # Used to work with edit and delete action
    resources :chromatographicals do
      match 'search', :via => [:post,:get], :on => :collection
      
      resources :posts do
        match 'search', :via => [:post,:get], :on => :collection
      end              
    end   
    resources :ieee_diags do
      match 'search', :via => [:post,:get], :on => :collection
    end        
    resources :table_chromatographicals do
      match 'search', :via => [:post,:get], :on => :collection
    end         
    resources :posts do
      match 'search', :via => [:post,:get], :on => :collection
    end      
    resources :chromatographical_duvals
    resources :chromatographical_duval_triangles    
    resources :chromatographical_duval_pentagons        
    resources :chromatographical_dga_diags   
    resources :gas_keys 
    #resources :chromatographical_uploads
  end

  # Physical Management routes 
  namespace :physical_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do
      resources :physicals do
        match 'delete', :via => [:get]
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :table_physicals do
        match 'search', :via => [:post,:get], :on => :collection
      end         
      resources :ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end  
      resources :report_ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end           
      resources :posts do
        match 'search', :via => [:post,:get], :on => :collection
      end     
      resources :physical_uploads, only: [:new, :create] do
        collection { post :import }
      end     
    end       
    # Used to work with edit and delete action
    resources :physicals do
      match 'search', :via => [:post,:get], :on => :collection
      
      resources :posts do
        match 'search', :via => [:post,:get], :on => :collection
      end          
    end   
    resources :table_physicals do
      match 'search', :via => [:post,:get], :on => :collection
    end        
    resources :posts do
      match 'search', :via => [:post,:get], :on => :collection
    end      
    resources :physical_uploads 
  end

  # Duval Management routes 
  namespace :duval_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do
      resources :pentagon_graphs, :triangle_graphs, :silicona_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end   
     
      resources :last_triangle_graphs, :last_pentagon_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end   

      resources :report_triangle_graphs, :report_pentagon_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end     
   
    end
    # Used to work with edit and delete action
    resources :pentagon_graphs, :triangle_graphs, :silicona_graphs do
      match 'search', :via => [:post,:get], :on => :collection
    end   
           
  end

  # Factor Management routes 
  namespace :furano_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do    
      resources :furanos do
        match 'delete', :via => [:get]
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :table_furanos do
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :furano_uploads, only: [:new, :create] do
        collection { post :import }
      end                    
    end
    # Used to work with edit and delete action
    resources :furanos do
      match 'search', :via => [:post,:get], :on => :collection
    end    
    resources :furano_uploads   
  end

  # Electrical Management routes 
  namespace :electrical_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do    
      resources :electricals do
        match 'search', :via => [:post,:get], :on => :collection
      end         
    end
    # Used to work with edit and delete action    
    resources :electricals do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Factor Management routes 
  namespace :factor_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do   
      resources :factors do
        match 'search', :via => [:post,:get], :on => :collection
      end         
    end
    # Used to work with edit and delete action   
    resources :factors do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # Devanado Management routes 
  namespace :devanado_management do
    # Used to pass transformer_id and validate with nested params
    resources :transformer do   
      resources :devanados do
        match 'delete', :via => [:get]   
        match 'search', :via => [:post,:get], :on => :collection
      end         
      resources :devanado_flows do
        match 'search', :via => [:post,:get], :on => :collection
      end   
      resources :devanado_templates do
        match 'delete', :via => [:get]   
        match 'search', :via => [:post,:get], :on => :collection
      end       
      resources :devanado_template_transformers do
        match 'search', :via => [:post,:get], :on => :collection
      end         
      resources :ieee_graphs do
        match 'search', :via => [:post,:get], :on => :collection
      end                    
    end
    # Used to work with edit and delete action   
    resources :devanados do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :devanado_flows do
      match 'search', :via => [:post,:get], :on => :collection
    end     
    resources :devanado_templates do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :devanado_template_transformers do
      match 'search', :via => [:post,:get], :on => :collection
    end        
    resources :ieee_graphs do
      match 'search', :via => [:post,:get], :on => :collection
    end           
  end

  # Bornal Management routes 
  namespace :bornal_management do
    resources :bornals do
      match 'search', :via => [:post,:get], :on => :collection
    end   
  end

  # IOT Management routes 
  namespace :iot_management do
    resources :iot 
  end

  # User Management routes 
  namespace :user_management do
    resources  :authentications do
       match 'search', :via => [:post,:get], :on => :collection
    end

    resources  :transformers do
       match 'search', :via => [:post,:get], :on => :collection
    end    

    resources  :search_transformer_per_users do
       match 'search', :via => [:post,:get], :on => :collection
    end 
        
    resources :grants

    resources :users do
      match 'search', :via => [:post,:get], :on => :collection
      match 'change_password',:via =>[:get]   
      match 'save_password',:via =>[:post], :on => :collection       
      resources :user_accesses  , except: [:index]       
    end    

    resources  :admin_users do
       match 'search', :via => [:post,:get], :on => :collection
    end 

    resources :accesses do
      match 'search', :via => [:post,:get], :on => :collection
    end    
    resources :profiles do
      match 'search', :via => [:post,:get], :on => :collection
    end   
    resources :audits do
      match 'search', :via => [:post,:get], :on => :collection
    end       
  end 


  # Config Management routes
  namespace :configuration_management do
    resources :configurations
  end

#############################################################
 
  get "signed_out" => "user_management/authentications#signed_out"


  get "forgot_password" => "user_management/authentications#forgot_password"
  get "password_sent" => "user_management/authentications#password_sent"
  put "forgot_password" => "user_management/authentications#send_password_reset_instructions"
  get "password_reset" => "user_management/authentications#password_reset"
  put "password_reset" => "user_management/authentications#new_password"

  #Root Configuration
  root 'user_management/authentications#new'

  get "/terms",   to: "static#terms"
  get "/privacy", to: "static#privacy"
  
  match '/404',       to: 'errors#not_found', via: :all
  match '/500',       to: 'errors#internal_server_error', via: :all
  match '/forbidden', to: 'errors#forbidden', via: :all  

end
