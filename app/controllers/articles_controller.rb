class ArticlesController < ApplicationController
  def index
    @articles = Article.all('**')
    respond_to do |format|
      format.html
      format.atom do
        @title = 'Bruno Rocha Toffoli'
        render :action => 'feed'
      end
    end
  end

  def show
    slug = params[:slug]
    unless @article = Article.find(slug)
      @category = Category.find(slug)
      unless @category
        render :text => t('article.not_found'), :status => 404, :layout => true
        return
      end
      @title = "Bruno Rocha Toffoli - #{@category.title}"
      render @category.index_path ? {:file => @category.index_path, :layout => true} :
        {:action => :show_category}
      return
    end
    @title = "Bruno Rocha Toffoli - #{@article.title}"
  end

  def feed
    category = Category.find params[:category]
    @articles = category.articles
    @title = "Bruno Rocha Toffoli - #{category.title}"
    respond_to {|f| f.atom}
  end
end
