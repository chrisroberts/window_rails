class WindowRailsController < ApplicationController

  unloadable

  # Make sure we kick any thing out that is making a request other
  # than openning a new window
  before_filter :redirect_out, :except => :open_window
  def redirect_out
    respond_to do |format|
      format.html do
        redirect_to '/'
      end
      format.js do
        render :update do |page|
          page.redirect_to '/'
        end
      end
    end
  end
  
  # Opens a new window
  # NOTE: It is important to note that the contents of the window will be opened
  # within an IFrame. This means links within the window will not be able to
  # communicate with the page around it (like closing the window)
  def open_window
    respond_to do |format|
      format.html do
        redirect_to '/'
      end
      format.js do
        opts = {}
        content = nil
        if(params[:window_url].blank?)
          content = {:url => params[:iframe_url]}
        else
          content = {:content_url => params[:window_url]}
        end
        base_key = params[:window_options] ? :window_options : 'window_options'
        if(params[base_key])
          params[base_key].keys.each do |key|
            opts[key.to_sym] = params[base_key][key]
          end
        end
        render :update do |page|
          page.open_window(content, opts || {})
        end
      end
    end
  end
end
