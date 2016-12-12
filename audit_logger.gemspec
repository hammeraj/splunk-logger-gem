Gem::Specification.new do |gem|
  gem.name        = 'audit_logger'
  gem.version     = '1.0'
  gem.date        = '2014-04-08'
  gem.summary     = "This gem is used to extend the existing Rails logger to log audit data. It loads custom formatting overrides within the loggers directory."
  gem.description = "Extend the Rails logger adding an Audit level"
  gem.authors     = ["Chris Shepherd"]
  gem.email       = 'chrisa.shepherd@gmail.com'
  gem.files       = ["lib/audit_logger.rb"]
  gem.homepage    = "https://github.com/ipipeline/splunk-logger-gem"
  gem.add_runtime_dependency 'rails', '>= 3.1'
end
