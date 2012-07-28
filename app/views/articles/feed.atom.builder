atom_feed(:language => I18n.locale, 'xml:base' => root_path) do |feed|
#, :instruct => {
#  'xml-stylesheet' => {:type => 'text/css', :href => "#{root_path}#{stylesheet_path 'markdown/active4d.css'}"},
#  'xml-stylesheet' => {:type => 'text/xsl', :href => "#{root_path}/xslt/feed.xsl"}}) do |feed|
  feed.title @title
  feed.updated @articles.first.updated_at
  feed.author do |author|
    author.name 'Bruno Rocha Toffoli'
  end

  @articles.each do |article|
    feed.entry(article, :id => slug_url(:slug => article.url),
     :url => url_for(:action => :show, :slug => article.url.to_s.split('/'), :escape => false, :only_path => false)) do |entry|
      entry.title article.title
      entry.author do |author|
        author.name 'Bruno Rocha Toffoli'
      end
#      entry.summary
#      entry.content article.body_html, :type => 'html'
      entry.content '<link rel="stylesheet" href="/stylesheets/markdown/active4d.css" type="text/css" />' +
        article.body_html.gsub(/([src|href]=")\//, "\\1#{root_path}/"), :type => 'html'
    end
  end
end
