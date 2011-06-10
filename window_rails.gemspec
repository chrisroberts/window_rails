$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'window_rails/version'
Gem::Specification.new do |s|
  s.name = 'window_rails'
  s.version = WindowRails::VERSION
  s.summary = 'Windows for Rails'
  s.author = 'Chris Roberts'
  s.email = 'chrisroberts.code@gmail.com'
  s.homepage = 'http://github.com/chrisroberts/window_rails'
  s.description = 'Windows for Rails'
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE', 'CHANGELOG.rdoc']
  s.add_dependency 'rails', '>= 2.3'
  s.add_dependency 'rails_javascript_helpers', '~> 1.0'
  s.files = %w(LICENSE README.rdoc CHANGELOG.rdoc) + Dir.glob("{app,files,lib,rails}/**/*")
end
