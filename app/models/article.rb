class Article
  attr_accessor :category_url, :info, :body, :url
  def self.all(category_url=nil)
    find("#{category_url}/**/*", true)
  end

  def self.find(article_url, return_array = false)
    articles_root = Rails.root + "articles/#{I18n.locale}"
    result = Pathname.glob("#{articles_root}/#{article_url}.txt").collect { |p|
      begin
        a = Article.new
        a.url = (rel=p.realpath.relative_path_from(articles_root)).sub(/.txt\z/,'')
        a.category_url = rel.dirname.to_s
        header, body = p.read.split("\n\n", 2)
        a.info = YAML.load(header)
        puts "info = #{a.info['updated_at']}"
        a.body = body
      rescue Exception => ex
        Rails.logger.error "Error processing YAML: #{p} - #{ex}"
        next nil
      end
      a
    }.compact.sort{|a,b| b.created_at <=> a.created_at}
    return result if return_array
    result.first
  end

  def self.last_articles(number=3)
    all().sort_by(&:updated_at).take number
  end

  def summary 
      #config = @config[:summary]
      max_length = 100
      delim = /[\t|\s]+?$/
      sum = (self.body =~ delim) ? self.body.split(delim).first : self.body.match(/(.{1,#{max_length}}.*?)(\n|\Z)/m).to_s
      Markdown.new((sum.length == self.body.length ? sum : sum.strip.sub(/\.\Z/, '&hellip;')).to_s.strip).to_html.html_safe
  end

  def created_at
    @created_at ||= parse_date(info['created_at'])
  end

  def updated_at
    @updated_at ||= parse_date(info['updated_at']) || created_at
  end

  def title
    @title ||= info['title']
  end

  def body_html
    Markdown.new(body.gsub(/^@@@ (\w+)\n(.*?)^@@@$/m){%Q{<div style="overflow: auto">
      #{CodeRay.scan($2, $1).div(:line_numbers => :table)}</div>}}).to_html.html_safe
  end

  def category
    Category.find category_url
  end

  def full_url
    "/#{I18n.locale}/articles/#{url}"
  end

  def slug(locale)
    "#{url.dirname.to_s + '/' if url.dirname.to_s != '.'}#{info["slug_#{locale}"]}"
  end
 private
  def parse_date(date)
    (DateTime.strptime(date, "%d/%m/%Y %H:%M") rescue DateTime.strptime(date, "%d/%m/%Y")).to_time rescue nil
  end
end
