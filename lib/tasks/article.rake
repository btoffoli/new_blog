namespace :article do
  desc 'Create a new article'
  task :new => :environment do
    title = ask('Title: ')
    slug = title.parameterize

    locale = ask("Locale (default: #{I18n.default_locale})[en|pt-BR]: ")
    locale = I18n.default_locale if locale.blank?
    article = {'title' => title, 'created_at' => Time.now.strftime("%d/%m/%Y %H:%M"), 'updated_at' => nil}.to_yaml
    article << "\nArticle content here."

    path = "#{Rails.root+"articles/#{locale}"}/geral/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug unless slug.blank?}.txt"

    unless File.exist? path
      File.open(path, "w") {|f| f.write article}
      puts "an article was created for you at #{path}."
    else
      puts "I can't create the article, #{path} already exists."
    end
  end

  def ask message
    print message
    STDIN.gets.chomp.strip
  end
end
