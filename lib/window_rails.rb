require 'window_rails/version'

if(defined?(Rails::Engine))
  require 'window_rails/engine'
else
  %w(window_rails_generators window_rails_view).each do |part|
    require "window_rails/#{part}"
  end
end
