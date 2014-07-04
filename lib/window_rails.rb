require 'window_rails/version'

# Windowing helper for Rails
module WindowRails
  autoload :Engine, 'window_rails/engine'
  autoload :Windows, 'window_rails/windows'
  autoload :Holder, 'window_rails/holder'
end

require 'window_rails/engine'
