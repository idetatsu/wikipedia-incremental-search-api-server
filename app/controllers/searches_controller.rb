class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :update, :destroy]

  # GET /searches
  def index
    @searches = Search.all

    render json: @searches
  end

  def latest
    limit = params[:limit].to_i
    if params[:limit].nil?
      limit = 10
    end

    @searches = Search.latest(limit)
    render json: @searches
  end

  # GET /searches/1
  def show
    render json: @search
  end

  # POST /searches
  def create
    keyword = search_params[:keyword].strip
    @search = Search.find_by(:keyword => keyword)
    if @search.nil?
      @search = Search.new(:keyword => keyword, :frequency => 0)
    end
    @search.frequency = @search.frequency + 1 
    @search.save
    if @search.save
      render json: @search, status: :created, location: @search
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /searches/1
  def update
    if @search.update(search_params)
      render json: @search
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  # DELETE /searches/1
  def destroy
    @search.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def search_params
      params.require(:search).permit(:keyword)
    end
end
