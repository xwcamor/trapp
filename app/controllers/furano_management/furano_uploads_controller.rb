module FuranoManagement
  class FuranoUploadsController < ApplicationController
    before_action :authenticate_user
    before_action :set_transformer

    def new
      @furano = @transformer.furanos.new
    end

    def create
      @furano = @transformer.furanos.new(furano_params)

      if @furano.save
        #redirect_to @transformer, notice: 'Datos Importados.'
        flash[:notice] = 'Se guardaron los datos de Furanos.'
        flash[:type_message] = 'success'        
      else
        render :new
      end
    end

    def import
      if params[:file].present? && params[:file].original_filename.ends_with?('.xlsx')
        begin
          errors = Furano.import(params[:file], @transformer.id)
          if errors.empty?
            redirect_to "/furano_management/transformer/#{@transformer.id}/furanos", notice: 'Datos Importados.'
            flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
            flash[:type_message] = 'success'               
          else
            redirect_to "/furano_management/transformer/#{@transformer.id}/furano_uploads/new", alert: "Datos importados, pero se encontraron los siguientes errores: #{errors.join(', ')}"
          end
        rescue => e
          redirect_to "/furano_management/transformer/#{@transformer.id}/furano_uploads/new", alert: "Error al importar los datos: #{e.message}" 
        end
      else
        redirect_to "/furano_management/transformer/#{@transformer.id}/furano_uploads/new", alert: 'Por favor selecciona un archivo con extensión xlsx.'
      end
    end

    private

    def set_transformer
      @transformer = Transformer.find(params[:transformer_id])
    end

    def furano_params
      params.require(:furano).permit!
    end
  end
end