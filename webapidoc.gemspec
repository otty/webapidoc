# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "webapidoc/version"

Gem::Specification.new do |s|
  s.name        = Webapidoc::NAME
  s.version     = Webapidoc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2012-12-03'

  s.summary     = "Static HTML Documentation for JSON Web APIs."
  s.description = "Create a static HTML Documentation for your JSON Web API."
  s.authors     = ["Adrian Fuhrmann"]
  s.email       = 'aliasng@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('maruku', '>= 0.6.1')
  s.add_dependency('sass', '>= 3.1.19')
  s.add_dependency('nokogiri', '>= 1.5.5')

  s.add_development_dependency 'rake'

  s.homepage = 'https://github.com/otty/webapidoc'
end