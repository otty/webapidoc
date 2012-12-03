# Webapidoc

## Installation

    gem install webapidoc

## Rails Generator

To copy sample config/webapidoc.yml and two sample files in app/documentation simply run

    rails g webapidoc:install

## Sample Rake Task

    require 'webapidoc'

    namespace :webapidoc do

      task :build do
        Webapidoc.build({:title => "Webapidoc"})
      end

    end
