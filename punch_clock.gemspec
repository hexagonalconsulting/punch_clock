$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "punch_clock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "punch_clock"
  s.version     = PunchClock::VERSION
  s.authors     = ["Dorian Lupu, Miguel Salas"]
  s.email       = ["miguel@kundigo.pro"]
  s.homepage    = "https://github.com/hexagonalconsulting/punch_clock"
  s.summary     = "A simple gem to track user presence in rails apps supported by action cable and devise."
  s.description = "A simple gem to track user presence in rails apps supported by action cable and devise."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency 'state_machines'
  s.add_dependency 'state_machines-activerecord'
  # Sidekiq
  s.add_dependency 'sidekiq', '4.2.10'
  s.add_dependency 'sidekiq-scheduler'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '~> 3.6'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'devise'
end
