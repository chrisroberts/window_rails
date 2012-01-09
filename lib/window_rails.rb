require 'window_rails/version'

if(defined?(Rails::Engine))
  require 'window_rails/engine'
else
  if(defined?(ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods))
    require 'window_rails/window_rails_generators'
  end
  %w(window_rails_windows window_rails_view).each do |part|
    require "window_rails/#{part}"
  end
end
