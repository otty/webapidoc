require 'webapidoc'

desc 'build webapi documentation'

namespace :webapidoc do
  task :build do
    WebApiDoc.build({:title => "WebApiDoc"})
  end

end