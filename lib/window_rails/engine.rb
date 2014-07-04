require 'window_rails'

module WindowRails
  # Hook helpers into rails
  class Engine < Rails::Engine
    require 'window_rails/view'
  end
end
