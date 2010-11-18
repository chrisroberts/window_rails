module WindowRailsView
  
  # name:: Name of the link
  # options:: Hash of optional values. These options are simply passed on to the activate_window method
  # Creates a link whose contents will be loaded into a window. Currently loaded content is within
  # an IFrame, which means that links within the window will not have the ability to communicate with
  # the DOM of the page around it. (This means you cannot close the window from a link within it)
  def link_to_window(name, options={})
    link_to_remote(name, :url => {:controller => :window_rails, :action => :open_window, :window_url => url_for(options.delete(:url)), :window_options => options})
  end
  
end