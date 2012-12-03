Gem::Specification.new do |s|
  s.name        = 'webapidoc'
  s.version     = '0.0.3'
  s.date        = '2012-12-03'

  s.summary     = "Static HTML Documentation for JSON Web APIs."
  s.description = "Create a static HTML Documentation for your JSON Web API."
  s.authors     = ["Adrian Fuhrmann"]
  s.email       = 'aliasng@gmail.com'

  s.files       << "lib/webapidoc.rb"
  s.files       << "lib/webapidoc/css/webapidoc.scss"
  s.files       << "lib/webapidoc/js/highlight.js"
  s.files       << "lib/webapidoc/js/html5.js"
  s.files       << "lib/webapidoc/js/jquery.js"
  s.files       << "lib/webapidoc/index.md.erb"
  s.files       << "lib/webapidoc/template.html.erb"
  s.files       << "app/documentation/sample.md.erb"
  s.files       << "config/webapidoc.yml"
  s.files       << "lib/tasks/webapidoc.rake"

  s.add_dependency('maruku', '~> 0.6.1')
  s.add_dependency('sass', '~> 3.1.19')

  s.homepage    =
      'http://rubygems.org/gems/webapidoc'
end