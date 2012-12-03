# Webapidoc

## Installation

    gem install webapidoc

## Sample Rake Task

    require 'webapidoc'

    namespace :webapidoc do

      task :build do
        Webapidoc.build({:title => "Webapidoc"})
      end

    end
