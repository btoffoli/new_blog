# encoding: utf-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def menu_link(title, slug)
    link_to title, slug_url(:slug => slug)
  end

  def root_path
    "http://#{request.host_with_port}"
  end

  def markdown_content(&content)
    Markdown.new(capture(&content)).to_html.html_safe
  end

  def change_locale_link
    locale = I18n.locale.to_s == 'en' ? 'pt-BR' : 'en'
    description = I18n.locale.to_s == 'en' ? 'Versão em português' : 'English version'
    options = request.path_parameters.merge(:locale => locale)
    options.merge!(:slug => @article.slug(locale).split('/')) if @article
    return link_to description, options
  end

  if Rails.env.production?
    def hosted_image_path(source)
      "http://usera.imagecave.com/toffoli/site/#{source}"
    end

    def hosted_image_tag(source, options={})
      image_tag hosted_image_path(source), options
    end
  else
    def hosted_image_path(source)
      image_path(source)
    end

    def hosted_image_tag(source, options={})
      image_tag source, options
    end
  end
end
