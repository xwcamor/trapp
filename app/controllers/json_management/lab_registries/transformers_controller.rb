class JsonManagement::LabRegistries::TransformersController < ApplicationController
  layout :false
  #require 'open-uri'
  # GET /json_management/transformers
  # GET /json_management/transformers.json 
  def index
     @list_transformers = Transformer.includes(:transformer_preservation,:oil_type,:connection_type,:conmutation_type,:transformer_type,:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0")     
  	 render json: @list_transformers
    
  end

  def show
    @transformer = Transformer.find( params[:id] )
  end

  def step1
    #@transformer = Transformer.find( params[:id] )
  end


  def search
    if params[:num_serie].present?
      transformers = Transformer.where("deleted=0 AND num_serie LIKE ?", "%#{params[:num_serie]}%")
      render json: transformers.map{|v| v.serializable_hash(only: [:id,:num_serie]) }
    else
      render json: []
    end
  end

  def update_div
    @transformer_id = params[:transformer_id]
    @transformer = Transformer.find_by_id(@transformer_id)
  end  

end 