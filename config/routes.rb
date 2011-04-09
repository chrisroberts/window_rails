Rails.application.routes.draw do |map|
  match '/window', :to => 'window_rails#open_window', :as => :open_window
end
