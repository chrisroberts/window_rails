$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'lib/version'
Gem::Specification.new do |s|
  s.name = 'window_rails'
  s.version = WindowRails::VERSION
  s.summary = 'Windows for Rails'
  s.author = 'Chris Roberts'
  s.email = 'chrisroberts.code@gmail.com'
  s.homepage = 'http://github.com/chrisroberts/window_rails'
  s.description = 'Windows for Rails'
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE', 'CHANGELOG.rdoc']
  s.add_dependency 'rails'
  s.files = %w(LICENSE README.rdoc CHANGELOG.rdoc init.rb install.rb uninstall.rb) + Dir.glob("{app,files,lib}/**/*")
end
