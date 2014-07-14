class ArticlesController < ApplicationController

  def index
    @articles = Article.cached_all
  end
end
