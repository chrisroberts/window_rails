module WindowRails
  class Engine < Rails::Engine
    
    rake_tasks do
      require 'window_rails/tasks'
    end

    # We do all our setup in here
    config.to_prepare do
      %w(window_rails_generators window_rails_view).each do |part|
        require "window_rails/#{part}"
      end
    end
  end
end
