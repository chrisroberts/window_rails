module WindowRails
  class Engine < Rails::Engine

    # We do all our setup in here
    config.to_prepare do
      if(defined?(ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods))
        require 'window_rails/window_rails_generators'
      end
      %w(window_rails_windows window_rails_view).each do |part|
        require "window_rails/#{part}"
      end
    end
  end
end
