class SiteController < ApplicationController
  def index
    @last_articles = Article.last_articles 2
  end

  def about

  end

  def curriculum
    render :layout => false
  end
end
