$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'window_rails/version'
Gem::Specification.new do |s|
  s.name = 'window_rails'
  s.version = WindowRails::VERSION.version
  s.summary = 'Windows for Rails'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'http://github.com/chrisroberts/window_rails'
  s.description = 'Windows for Rails'
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README.md', 'LICENSE', 'CHANGELOG.md']
  s.add_dependency 'rails', '>= 3.0'
  s.add_dependency 'rails_javascript_helpers', '~> 1.0'
  s.files = %w(LICENSE README.md CHANGELOG.md) + Dir.glob("lib/**/*")
end
