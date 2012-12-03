require 'webapidoc'
require 'rails'

module WebApiDoc
  class Railtie < Rails::Railtie
    railtie_name :webapidoc

    rake_tasks do
      load "tasks/webapidoc.rake"
    end
  end
end