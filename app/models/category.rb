class Category
  attr_accessor :info, :url, :system_path, :index_path
  def self.all(parent=nil)
    find("#{parent}/*", true).sort_by &:order
    #find("#{parent}/*", true).sort_by {|c| c.order}
  end

  def self.find(url, return_array = false)
    articles_root = Rails.root + "articles/#{I18n.locale}"
    res = Pathname.glob("#{articles_root}/#{url}/").collect { |path|
      Category.new.tap do |c|
        c.info = YAML.load(((c.system_path = path.realpath) + 'info.yml').read) rescue {}
        c.url = c.system_path.relative_path_from(articles_root).to_s
        c.index_path = path + 'index.html.erb'
        c.index_path = nil unless c.index_path.exist?
      end
    }
    return res if return_array
    res.first rescue nil
  end

  def title
    info['title']
  end

  def description
    info['description']
  end

  def order
    info['order']
  end
  
  def articles
    @articles ||= Article.all(url)
  end
end
