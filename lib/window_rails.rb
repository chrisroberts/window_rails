require 'window_rails/window_rails_view'
require 'window_rails/weindow_rails_generators'

# Load everything into rails
if(defined? Rails)
  ActionView::Base.send :include, WindowRailsView
  ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send :include, WindowRailsGenerators
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'install.rb') # Always included in case we are gem'ed
end