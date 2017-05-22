class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    @res = {}
    if params[:keyword].nil? or params[:keyword].empty?
      page = params[:page] ||= 1
      articles = Article.all.page(page)
      total = Article.count
      @res = {articles: articles, total: total}
    else
      page = params[:page] ||= 1
      articles = Article.search(params[:keyword])
      total = articles.size
      articles_page = articles.page(page)
      @res = {articles: articles_page, total: total}
    end
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
