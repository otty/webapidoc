# Webapidoc

## Installation

    gem install webapidoc

## Rails Generator

To copy sample config/webapidoc.yml and sample files in app/documentation simply run

    rails g webapidoc:install

## Sample Rake Task

    require 'webapidoc'

    namespace :webapidoc do

      task :build do
        Webapidoc.build({:title => "Webapidoc"})
      end

    end

## Provide URL for live API Querys

set url option to a valid JSON API URL to use live querys


# Rendering Partials

like in rails:

    <%= partial :welcome_message %>

