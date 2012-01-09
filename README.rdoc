== WindowRails (for jQuery)

WindowRails is a plugin for Rails that provides easy to use AJAXy windows. It is based
completely on {jQueryUI}[http://jquery-ui.com] with helpers for Rails to make it easy to 
use from a Rails app.

WindowRails is now happily compatible with Rails 2 and Rails 3 (and now 3.1).

== Requirements

* jQuery
* jQuery-UI with Dialog widget enabled

== Installation

Add window_rails to your application Gemfile:

  gem 'window_rails'

=== Basic examples to get you started

=== Remote calls to create a window

  # view
  <%= link_to_remote('Link', :url => my_route_path) %>


  # controller 

  def action
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.open_window(
            {:partial => 'action_partial'},
            :width => 400,
            :height => 500,
            :title => 'My Window',
            :window => 'unique_window_name'
          )
        end
      end
    end
  end

  # or via JS template:
  # app/views/my_resources/action.js.erb

  <%=
    open_window(
      {:partial => 'action_partial'},
      :width => 400,
      :height => 500,
      :title => 'My Window',
      :window => 'unique_window_name'
    )
  %>

== Window Interactions

Examples are shown using the old generator style. For rails 3.1 and beyond, the methods should be defined
within the JS views

==== Opening a window via AJAX
  def open_my_window
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.open_window({:partial => 'my_partial'}, :width => 400, :height => 200, :window => 'my_window')
        end
      end
    end
  end

==== Updating a window via AJAX
  def update_my_window
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.update_window({:partial => 'new_partial'}, :window => 'my_window')
        end
      end
    end
  end
  
==== Closing a window via AJAX
  def close_my_window
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.close_window(:window => 'my_window')
        end
      end
    end
  end

== Documentation

{WindowRails documentation}[http://chrisroberts.github.com/window_rails]

== Bugs/Features

{Issues}[http://github.com/chrisroberts/window_rails/issues]

== License

* WindowRails is released under an MIT license
