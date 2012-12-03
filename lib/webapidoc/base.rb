
module Webapidoc

  def self.gem_libdir
    t = ["#{File.dirname(File.expand_path($0))}/../lib/#{Webapidoc::NAME}",
         "#{Gem.dir}/gems/#{Webapidoc::NAME}-#{Webapidoc::VERSION}/lib/#{Webapidoc::NAME}",
         "#{File.dirname(__FILE__)}/lib/#{Webapidoc::NAME}"
        ]
    t.each {|i| return i if File.readable?(i) }
    raise "paths are invalid: #{t}"
  end

  def self.build

    publicDir = "public/documentation"
    docDir = "app/documentation"
    libDir = gem_libdir

    # get config hash
    configFile = 'config/webapidoc.yml'
    @data = YAML.load_file(configFile).freeze

    puts "building webapidoc for " + @data["title"]
    puts "api url: " + @data["url"]

    # clean up
    FileUtils.remove_dir publicDir if File.exists?(publicDir)

    # create paths
    FileUtils.mkdir_p publicDir
    FileUtils.mkdir publicDir + "/css"
    FileUtils.mkdir publicDir + "/js"

    # copy jquery
    FileUtils.copy(libDir + "/js/jquery.js", publicDir + "/js/jquery.js")

    # copy highlight
    FileUtils.copy(libDir + "/js/highlight.js", publicDir + "/js/highlight.js")

    # compile webapidoc style
    sass_filename = libDir + "/css/webapidoc.scss"
    css = Sass::Engine.for_file(sass_filename, {:style => :compressed}).render
    File.open(publicDir + "/css/webapidoc.css", "wb") {|f| f.write(css) }

    # parse chapters and create html from md
    @chapters = []

    # get chapter info
    @data["chapters"].each_with_index do | chapter, idx|

      inFile = "#{docDir}/#{chapter["file"]}.md"
      outFile = chapter["file"] + ".html"

      if File.exists?(inFile + ".erb" )
        inFile = inFile + ".erb"
      end

      if File.exists?(inFile)
        contents = File.open(inFile, 'r').read
      else
        puts "file not found: #{inFile}"
        next
      end

      @chapters << { :name => chapter["name"],  :out => outFile, :in => inFile}
    end

    @chapters.each_with_index do | chapter, idx|

      contents = ERB.new(File.open(chapter[:in], 'r').read).result(binding)
      maruku = Maruku.new(contents)

      # get content info for subsections ( side pane navigation )
      sections = []
      maruku.each_element(:header) do | el |
        next unless el.meta_priv[:level] == 2
        sections << el.children[0]
      end

      chapter[:html] = maruku.to_html
      chapter[:sections] = sections

    end

    # open template
    template = "#{libDir}/template.html.erb"

    # build chapter files
    @chapters.each do | chapter |

      # bindings
      @html = chapter[:html]
      @current = chapter
      puts "building #{chapter[:name]}"
      # write it
      File.open("#{publicDir}/#{chapter[:out]}", 'w') { |file| file.write(ERB.new(File.open(template, 'r').read).result(binding)) }
    end
  end
end