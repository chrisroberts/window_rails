module RabidCore
  class Engine < Rails::Engine
    
    rake_tasks do
      require 'window_rails/tasks'
    end

    # We do all our setup in here
    config.to_prepare do
      %w(window_rails_generators window_rails_view).each do |part|
        require "window_rails/#{part}"
      end
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion(
        :plugins => Dir.glob(
          File.join(Rails.root, 'public', 'window_rails', 'javascripts', '*.js')
        ).map{|file| file.sub(File.join(Rails.root, 'public'), '')}
      )
      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion(
        :plugins => Dir.glob(
          File.join(Rails.root, 'public', 'window_rails', 'stylesheets', '*.css')
        ).map{|file| file.sub(File.join(Rails.root, 'public'), '')}
      )
    end
  end
end
