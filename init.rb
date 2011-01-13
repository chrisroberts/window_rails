require 'window_rails/window_rails_view'
require 'window_rails/window_rails_generators'

# Load everything into rails
if(defined? Rails)
  ActionView::Base.send :include, WindowRailsView
  ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send :include, WindowRailsGenerators
end
