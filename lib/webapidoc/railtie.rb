require 'webapidoc'
require 'rails'

module WebApiDoc
  class WebApiDocTask < Rails::Railtie
    rake_tasks do
      require "lib/tasks/webapidoc.rake"
    end
  end
end