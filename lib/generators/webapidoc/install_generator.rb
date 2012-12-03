#lib/generators/gemname/install_generator.rb
require 'rails/generators'
require "webapidoc"

module Webapidoc
  class InstallGenerator < Rails::Generators::Base
    desc "generate api documentation sample"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    puts "SOURCE ROOT:" + source_root
    puts "LIB ROOT:" + Webapidoc.gem_libdir

  end
end