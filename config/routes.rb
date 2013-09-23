if(Rails.version.split('.').first.to_i < 3)
  ActionController::Routing::Routes.draw do |map|
    map.open_window 'window_rails/open_window', :controller => :window_rails, :action => :open_window
  end
else
  Rails.application.routes.draw do
    if(Rails.version.split('.').first.to_i < 4)
      match 'window_rails/open_window' => 'window_rails#open_window', :as => :open_window
    else
      get 'window_rails/open_window', to: 'window_rails#open_window', :as => :open_window
    end
  end
end
