#lib/generators/gemname/install_generator.rb
require 'rails/generators'
require "webapidoc"

module Webapidoc
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "generate api documentation sample"

      def copy_files
        source_root ||= File.join(File.dirname(__FILE__), 'templates')

        # create paths
        FileUtils.mkdir_p "app/documentation"

        # copy files
        FileUtils.copy(source_root + "/documentation.md.erb", "app/documentation")
        FileUtils.copy(source_root + "/_partial.md.erb", "app/documentation")
        FileUtils.copy(source_root + "/webapidoc.yml", "config")

        puts "done"
      end
    end
  end
end