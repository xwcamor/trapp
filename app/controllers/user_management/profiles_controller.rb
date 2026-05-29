class UserManagement::ProfilesController < ApplicationController
   
  before_action :authenticate_user
 
#################################################

  def index
 
    if user_permission.include?(9)
      
 
      @profiles = Profile.all
 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
   
  end


###############################################

  def new
    if user_permission.include?(10)
      @countries = Country.where("deleted=0")
      @profile = Profile.new

      @accesses = Access.where(parent_id: 0).order('name ASC').map do |access|
        { parent: access, children: Access.where(parent_id: access.id).order('name ASC') }         
      end

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end

  end

###############################################
  
  def create

    @profile = Profile.new(profile_params)
    @accesses = Access.all
    
    if @profile.save
      @accesses.each do |access|
        if params["access_"+access.id.to_s] == "on"
          profile_access = ProfileAccess.new()
          profile_access.access_id = access.id
          profile_access.profile_id = @profile.id
          profile_access.save
        end
      end
        
      @condition= ProfileAccess.where(profile_id: @profile.id).count
      if @condition.to_i == 0
        @profile.destroy
        flash[:notice] = 'Por favor seleccion al menos 1.'
        flash[:type_message] = 'danger'
        redirect_to [:new_user_management,:profile]
      else

        #  ADD CUStOMERS TO USER ACCESS
        if params[:profile][:country_id].present?
          params[:profile][:country_id].each do |profile_country|
            profile_country = ProfileCountry.new( profile_id: @profile.id, country_id: profile_country )
            profile_country.save
          end
        end


        flash[:notice] = 'Data creada.'
        flash[:type_message] = 'success'
        redirect_to [:user_management, @profile]
      end
    else
      flash[:notice] = 'Eror al crear.'
      flash[:type_message] = 'danger'
      redirect_to [:new_user_management,:profile]
    end
  end

#############################################

  def show
    if user_permission.include?(11)

      @profile = Profile.find params[:id]
      @profile_access= ProfileAccess.where(profile_id: @profile.id).joins(:access).order("accesses.name")
      @access = Access.where('id IN (?)',@profile_access.map { |e| e.access_id }).order("name ASC")

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

###############################################

  def edit

    if user_permission.include?(12)
      @countries = Country.where("deleted=0")

      @profile = Profile.find(params[:id])
      #ARRAY
      @profile_access = ProfileAccess.where('profile_id = ?',@profile.id)
      @accesses = Access.where(parent_id: 0).order('name ASC').map do |access|
        { parent: access, children: Access.where(parent_id: access.id).order('name ASC') }         
      end
      #CHECKED
      @px_access= ProfileAccess.where(profile_id: @profile.id).joins(:access)
      @access = Access.where('id IN (?)',@px_access.map { |e| e.access_id })


    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end

  end

###############################################
  
  def update

    @profile = Profile.find(params[:id])
    @accesses = Access.all
    
    if @profile.update(profile_params)
      
      @profile.profile_accesses.each do |pa|
        pa.destroy
      end 
 
      @accesses.each do |access|
        if params["access_"+access.id.to_s] == "on"
          profile_access = ProfileAccess.new()
          profile_access.access_id = access.id
          profile_access.profile_id = @profile.id
          profile_access.save
        end
      end

      @condition= ProfileAccess.where(profile_id: @profile.id).count
      if @condition.to_i == 0
        @profile.destroy
        flash[:notice] = 'Selecciona al menos 1.'
        flash[:type_message] = 'danger'
        redirect_to [:edit_user_management,:profile]
      else
        if params[:profile][:country_id].present?
          @borrado = ProfileCountry.where(profile_id: @profile.id).destroy_all

          params[:profile][:country_id].each do |profile_country|
            profile_country = ProfileCountry.new( profile_id: @profile.id, country_id: profile_country )
            profile_country.save
            @borrado = ProfileCountry.where(country_id: nil).destroy_all
          end
        end        
        flash[:notice] = 'Data actualizada.'
        flash[:type_message] = 'success'
        redirect_to [:user_management, @profile]
      end

    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end

  end

################################################ 

  def destroy

    if user_permission.include?(13)

      @profile = Profile.find(params[:id])

      @profile_accesses = ProfileAccess.where(profile_id: params[:id])
      @profile_accesses.each do |profile_access|
        profile_access.destroy
      end
      @profile.destroy      

      flash[:notice] = 'Data eliminada.'
      flash[:type_message] = 'success'
      redirect_to [:user_management,:profiles]

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end

  end

###############################################

  private
    def profile_params
       params.require(:profile).permit!
    end

################################################

end
