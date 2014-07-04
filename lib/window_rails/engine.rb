require 'window_rails'

module WindowRails
  # Hook helpers into rails
  class Engine < Rails::Engine
    config.to_prepare do
      require 'window_rails/windows'
    end
  end
end
