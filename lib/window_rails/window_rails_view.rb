module WindowRailsView
  
  # name:: Name of the link
  # options:: Hash of options values.
  # Creates a link to a window. Content is defined by a url in the options hash using :url or :iframe. 
  # If :url is used, the content is loaded into the window within the page. If :iframe is used
  # the content is loaded into the window within an IFrame on the page. Generally, if you are calling
  # a method that simply renders out a partial, you want to use :url. If you are calling something
  # that returns an entire page, :iframe will likely be the ticket.
  def link_to_window(name, options={})
    link_to_remote(name, :url => {:controller => :window_rails, :action => :open_window, :window_url => url_for(options.delete(:url)), :iframe_url => url_for(options.delete(:iframe)), :window_options => options})
  end
  
end
ActionView::Base.send :include, WindowRailsView
