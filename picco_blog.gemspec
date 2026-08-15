$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "picco_blog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "picco_blog"
  s.version     = PiccoBlog::VERSION
  s.authors     = ["Brandon Bango"]
  s.email       = ["brandon@acentrosys.com"]
  s.homepage    = "https://github.com/acentro/picco_blog"
  s.summary     = "PiccoBlog is a simple Ruby on Rails markdown blog engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 7.1", "< 9"
  s.add_dependency 'acts-as-taggable-on', '>= 10.0'
  s.add_dependency 'kaminari', '>= 1.2'
  s.add_dependency 'friendly_id', '~> 5.5'
  s.add_dependency 'redcarpet', '>= 3.6'
  s.add_dependency 'dragonfly', '>= 1.1.1'
  s.add_dependency 'mime-types'

  # Rails 8.1's sqlite3 adapter calls `gem "sqlite3", ">= 2.1"` at require time.
  # That is invisible to Bundler at resolve time, so a `~> 1.7` pin installs
  # cleanly and then fails at boot with "can't activate sqlite3 (>= 2.1)".
  s.add_development_dependency "sqlite3", ">= 2.1"
  s.add_development_dependency 'minitest' 
  s.add_development_dependency 'capybara' 
end
