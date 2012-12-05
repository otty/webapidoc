
module Webapidoc

  @@docDir = "app/documentation"
  @@publicDir = "public/documentation"
  @@configFile = 'config/webapidoc.yml'

  def self.partial(template)
    # rails like _ templates, simple injection
    template = template.to_s.split('/')
    template[ template.length - 1 ] = '_' + template[ template.length - 1 ]
    template = template.join('/')
    inFile = @@docDir + "/" + template + ".md"

    if !File.exists?(inFile)
      inFile = inFile + ".erb"
    end

    if !File.exists?(inFile)
      puts "partial not found: #{inFile}"
      return
    end

    # read partials contents and inject it
    File.open(inFile, 'r').read
  end

  def self.libDir
    File.dirname(__FILE__)
  end

  def self.build
    # get config hash
    @data = YAML.load_file(@@configFile).freeze

    puts "building webapidoc for " + @data["title"]
    puts "api url: " + @data["url"] if @data["url"]

    # clean up
    FileUtils.remove_dir @@publicDir if File.exists?(@@publicDir)

    # create @s
    FileUtils.mkdir_p @@publicDir
    FileUtils.mkdir @@publicDir + "/css"

    # copy javascripts
    FileUtils.cp_r(libDir + "/js", @@publicDir + "/js")

    # compile webapidoc style
    sass_filename = libDir + "/css/webapidoc.scss"
    css = Sass::Engine.for_file(sass_filename, {:style => :compressed}).render
    File.open(@@publicDir + "/css/webapidoc.css", "wb") {|f| f.write(css) }

    # open index file
    inFile = "#{@@docDir}/documentation.md"
    # look for erb
    if !File.exists?(inFile)
      inFile = inFile + ".erb"
    end
    # not found?
    if !File.exists?(inFile)
      puts "documentation not found: #{inFile}"
      exit 0
    end

    # open file
    contents = ERB.new(File.open(inFile, 'r').read).result(binding)
    maruku = Maruku.new(contents)

    # build html
    html = Nokogiri::HTML(maruku.to_html)

    # build chapters
    @chapters = []
    @chapters = html.xpath('//body').children.inject([]) do |chapters_hash, child|
      # build chapter
      if child.name == 'h1'
        title = child.inner_text
        anchor = title.downcase.gsub(/[^\d\w\s]/, "").tr(" ", "_")
        chapters_hash << { :title => title, :contents => '', :file => anchor}
      end

      next chapters_hash if chapters_hash.empty?
      chapters_hash.last[:contents] << child.to_xhtml
      chapters_hash
    end

    # build sections
    @sections = []
    cidx = -1
    html.xpath('//body').children.inject([]) do |chapters_hash, child|
      # store sections for navigation
      if child.name == 'h1' or child.name == 'h2' or child.name == 'h3'
        title = child.inner_text
        anchor = title.downcase.gsub(/[^\d\w\s]/, "").tr(" ", "_")
        level = child.name[-1, 1]
        cidx = cidx + 1 if level == "1"
        next unless @chapters[cidx].present?
        file = @chapters[cidx][:file]
        @sections << {:title => title, :file => file, :anchor => anchor, :level => level}
      end
    end

    # open template
    template = "#{libDir}/template.html.erb"

    # write each chapter to file
    @chapters.each_with_index do | chapter, idx |
      outFile = "#{@@publicDir}/#{chapter[:file]}.html"
      puts idx.to_s + ":" + chapter[:title] + " > " + outFile
      # convert md to html
      @html = chapter[:contents]
      # write it
      File.open(outFile, 'w') { |file| file.write(ERB.new(File.open(template, 'r').read).result(binding)) }
    end
  end
end
