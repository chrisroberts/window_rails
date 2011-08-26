ActionController::Routing::Routes.draw do |map|
  if(Rails.version.split('.').first.to_i < 3)
    map.open_window 'window_rails/open_window', :controller => :window_rails, :action => :open_window
  else
    match 'window_rails/open_window' => 'window_rails#open_window'
  end
end
