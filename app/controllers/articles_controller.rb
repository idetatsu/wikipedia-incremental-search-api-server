class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    page = params[:page].to_i
    if params[:page].nil?
      page = 1
    end

    results_per_page = params[:results_per_page].to_i
    if params[:results_per_page].nil?
      results_per_page = 10
    end

    to_skip = (page-1) * results_per_page

    @articles = Article.offset(to_skip).limit(results_per_page)
    @total = Article.count_by_sql("SELECT MAX(ROWID) from articles")
    @res = { articles: @articles, total: @total }
    render json: @res
  end

  def search
    keyword = params[:keyword] ||= ''
    page = params[:page].to_i
    if params[:page].nil?
      page = 1
    end

    results_per_page = params[:results_per_page].to_i
    if params[:results_per_page].nil?
      results_per_page = 10
    end

    @articles, @total = Article.search(keyword, page, results_per_page)
    @res = { articles: @articles, keyword: keyword,  total: @total }
    render json: @res
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.require(:article).permit(:title, :abstract, :url)
    end
end
