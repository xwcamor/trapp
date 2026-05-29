module PhysicalManagement
  class PhysicalUploadsController < ApplicationController
    before_action :authenticate_user
    before_action :set_transformer

    def new
      @physical = @transformer.physicals.new
    end

    def create
      @physical = @transformer.physicals.new(physical_params)

      if @physical.save
        #redirect_to @transformer, notice: 'Datos Importados.'
        flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
        flash[:type_message] = 'success'        
      else
        render :new
      end
    end

    def import
      if params[:file].present? && params[:file].original_filename.ends_with?('.xlsx')
        begin
          errors = Physical.import(params[:file], @transformer.id)
          if errors.empty?
            redirect_to "/physical_management/transformer/#{@transformer.id}/physicals", notice: 'Datos Importados.'
            flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
            flash[:type_message] = 'success'               
          else
            redirect_to "/physical_management/transformer/#{@transformer.id}/physical_uploads/new", alert: "Datos importados, pero se encontraron los siguientes errores: #{errors.join(', ')}"
          end
        rescue => e
          redirect_to "/physical_management/transformer/#{@transformer.id}/physical_uploads/new", alert: "Error al importar los datos: #{e.message}" 
        end
      else
        redirect_to "/physical_management/transformer/#{@transformer.id}/physical_uploads/new", alert: 'Por favor selecciona un archivo con extensión xlsx.'
      end
    end

    private

    def set_transformer
      @transformer = Transformer.find(params[:transformer_id])
    end

    def physical_params
      params.require(:physical).permit!
    end
  end
end