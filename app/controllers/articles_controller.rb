class ArticlesController < ApplicationController

  def index
    @articles = Article.cached_all
  end

  def show
    @article = Article.cached_find(params[:id])
    @comments = @article.cached_comments
  end
end
