lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin/searchable_select/version'

Gem::Specification.new do |spec|
  spec.name          = 'rs-activeadmin-searchable_select'
  spec.version       = ActiveAdmin::SearchableSelect::VERSION
  spec.summary       = 'Use searchable selects based on Select2 in Active Admin forms and filters.'
  spec.license       = 'MIT'
  spec.authors       = ['Rocket Sensei']
  spec.email         = 'glebtv@gmail.com'
  spec.homepage      = 'https://github.com/glebtv/activeadmin-searchable_select'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  spec.required_ruby_version = ['>= 2.1', '< 4']

  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler', ['>= 1.5', '< 3']
  spec.add_development_dependency 'combustion', '~> 1.5'
  spec.add_development_dependency 'database_cleaner-active_record', '~> 2.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails', '~> 6.0'
  spec.add_development_dependency 'sqlite3', '~> 2.1'

  spec.add_development_dependency 'capybara', '~> 3.39'
  spec.add_development_dependency 'capybara-playwright-driver', '~> 0.5'
  spec.add_development_dependency 'puma', '~> 6.0'

  spec.add_development_dependency 'propshaft'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rubocop', '~> 1.50.0'
  spec.add_development_dependency 'semmy', '~> 1.0'

  spec.add_dependency 'activeadmin', '~> 4.0.0.beta'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
