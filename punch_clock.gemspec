$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "punch_clock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "punch_clock"
  s.version     = PunchClock::VERSION
  s.authors     = ["Dorian LUPU"]
  s.email       = ["dorian.lupu@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PunchClock."
  s.description = "TODO: Description of PunchClock."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.1"

  s.add_development_dependency "sqlite3"
end
