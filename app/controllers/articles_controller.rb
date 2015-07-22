class ArticlesController < ApplicationController

  def index
    @articles = Article.cached_all
  end

  def show
    @article = Article.cached_find(params[:id])
    # @comments = Article.cached_comments(params[:id])
    @comments = Comment.cached_all(params[:id])
  end
end
