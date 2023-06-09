class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  include CloudinaryHelper

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @image_urls = @article.photos.map { |photo| cl_image_path(photo.key, width: 600, height: 400, crop: :fill) }
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    @article.save
    redirect_to article_path(@article)
  end

  def edit
  end

  def update
    @article.update(article_params) # update the article with the params from the form
    redirect_to article_path(@article) # redirect to the show page
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  # Strong params: white list of sanitized input that can be used to update database records.
  def article_params
    params.require(:article).permit(:name, :text, :title, :rich_body, :description, :body, photos: [])
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
