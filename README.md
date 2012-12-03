# WebApiDoc

## Installation

    gem install webapidoc

## Sample Rake Task

    require 'webapidoc'

    namespace :webapidoc do

      task :build do
        WebApiDoc.build({:title => "WebApiDoc"})
      end

    end
