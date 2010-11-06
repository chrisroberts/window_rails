module WindowRailsView
  
  # name:: Name of the link
  # options:: Hash of optional values. These options are simply passed
  # on to the activate_window method
  def link_to_window(name, options={})
    link_to_remote(name, :url => {:controller => :window_rails, :action => :open_window, :window_url => url_for(options.delete(:url)), :window_options => options})
  end
  
end