$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'webapidoc'
  s.version     = '0.0.3'
  s.date        = '2012-12-03'

  s.summary     = "Static HTML Documentation for JSON Web APIs."
  s.description = "Create a static HTML Documentation for your JSON Web API."
  s.authors     = ["Adrian Fuhrmann"]
  s.email       = 'aliasng@gmail.com'

  s.files         = `git ls-files`.split("\n")

  s.require_paths = ["lib", "tasks"]

  s.add_dependency('maruku', '>= 0.6.1')
  s.add_dependency('sass', '>= 3.1.19')

  s.homepage    =
      'http://rubygems.org/gems/webapidoc'
end