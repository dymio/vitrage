$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "vitrage/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vitrage"
  s.version     = Vitrage::VERSION
  s.authors     = ["Ivan Dymkov"]
  s.email       = ["mstrdymio@gmail.com"]
  s.homepage    = "https://github.com/dymio/vitrage"
  s.summary     = "Web-Page content manage for Rails, based on separated content pieces (blocks)"
  s.description = "Vitrage allows store and manage your Rails application web-pages content as separated pieces of different types: text, image, slider, several-columned text etc. Pieces are objects of different Rails models having their specific views for show and edit. Vitrage allows you inline editing of content pieces."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"

  s.add_development_dependency "sqlite3"
end
