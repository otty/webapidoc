# WebApiDoc
# Static HTML Documentation for JSON APIs

#
# Example:
#   >> WebApiDoc.build({:title => "WebApiDoc"})
#
# Arguments:
#   - data object accessible via @data in templates
#
# Info
#   - chapter info is accessible via @chapters in templates
#

require 'maruku'
require 'yaml'
require 'fileutils'
require 'erb'
require 'sass'

require 'webapidoc/railtie' if defined?(Rails)

class WebApiDoc

  def self.build(data=nil)

    @data = data

    publicDir = "public/documentation"
    docDir = "app/documentation"
    libDir = "lib/webapidoc"

    # get config hash
    config = YAML.load_file('config/webapidoc.yml').freeze

    puts "building webapidoc for " + config["title"]

    # clean up
    FileUtils.remove_dir publicDir if File.exists?(publicDir)

    # create paths
    FileUtils.mkdir_p publicDir
    FileUtils.mkdir publicDir + "/css"
    FileUtils.mkdir publicDir + "/js"

    # copy jquery
    FileUtils.copy(libDir + "/js/jquery.js", publicDir + "/js/jquery.js")

    # copy highlighter
    FileUtils.copy(libDir + "/js/highlight.js", publicDir + "/js/highlight.js")

    # compile webapidoc style
    sass_filename = libDir + "/css/webapidoc.scss"
    css = Sass::Engine.for_file(sass_filename, {:style => :compressed}).render
    File.open(publicDir + "/css/webapidoc.css", "wb") {|f| f.write(css) }

    # parse chapters and create html from md
    @chapters = []

    # get chapter info
    config["chapters"].each_with_index do | chapter, idx|

      inFile = "#{docDir}/#{chapter["file"]}.md"
      outFile = "%02d_%s.html" % [idx.to_s, chapter["file"]]

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
        next unless el.meta_priv.to_s == "level2"
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

    # build index file, reset bindings
    contents = ERB.new(File.open("#{libDir}/index.md.erb", 'r').read).result(binding)

    @html = Maruku.new(contents).to_html
    @current = {}
    File.open("#{publicDir}/index.html", 'w') { |file| file.write(ERB.new(File.open(template, 'r').read).result(binding)) }

  end

end