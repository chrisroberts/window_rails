module WindowRailsView
  
  # name:: Name of the link
  # options:: Hash of optional values. These options are simply passed
  # on to the activate_window method
  def link_to_window(name, options={})
    link_to_remote(name, :url => {:controller => :window_rails, :action => :open_window, :window_url => url_for(options.delete(:url)), :window_options => options})
  end
  
end

module WindowRailsGenerators
  
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  
  # msg:: Alert message
  # options:: Hash of options values for the alert window
  # Opens an alert window
  def open_alert_window(msg, options={})
    options[:width] ||= 200
    self << "Dialog.alert('#{escape_javascript(msg)}', {#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(',')}});"
  end

  # msg:: Confirmation message
  # options:: Hash of options values for the confirmation window
  # Opens a confirmation window
  def open_confirm_window(msg, options={})
    options[:width] ||= 200
    self << "Dialog.confirm('#{escape_javascript(msg)}', {#{options.map{|k,v|"#{escape_javascript(k)}:'#{escape_javascript(v)}'"}.join(',')}});"
  end
  
  # msg:: Information message
  # options:: Hash of options values for info window
  # Open an information window
  def open_info_window(msg, options={})
    self << "Dialog.info('#{escape_javascript(msg)}', {#{options.map{|k,v|"#{escape_javascript(k)}:'#{escape_javascript(v)}'"}.join(',')}});"
  end
  
  # Close an information window
  def close_info_window
    self << "Dialog.closeInfo();"
  end
  
  # Update the contents of an information window
  def update_info_window(msg)
    self << "Dialog.setInfoMessage('#{escape_javascript(msg)}');"
  end
  
  # content:: Updated content
  # options:: Hash of options
  #   * window -> Name of the window to update (defaults to last window)
  # Updates the window with the new content. If the content is a string, it will
  # be placed into the window. If it is a Hash, it will be fed to render and the
  # result will be placed in the window (basically an easy way to integrate partials:
  # page.update_window(:partial => 'my_parital'))
  def update_window(content, options={})
    win = options.delete(:window)
    if(content.is_a?(Hash))
      content = render(content)
    end
    content = escape_javascript(content)
    win = escape_javascript(win) if win
    if(win)
      self << "if(Windows.existsByName('#{win}')){"
      self << "  Windows.getWindowByName('#{win}').setHTMLContent('#{content}');"
      self << "} else {"
      self << "  alert('Unexpected error. Failed to locate correct window for output.');"
      self << "}"
    else
      self << "Windows.windows.values().last().setHTMLContent('#{content}');"
    end
  end
  
  # content:: Content for window
  # options:: Hash of options
  #   * modal -> Window should be modal
  #   * window -> Name to reference window (used for easy updating and closing)
  #   * constraints -> Hash containing top,left,right,bottom values for padding from edges. False value will turn off constraints (window can travel out of viewport)
  #   * url -> URL to load into the window
  #   * width -> Width of the window
  #   * height -> Height of the window
  #   * className -> Theme name for the window
  # Creates a new window and displays it at the center of the viewport.
  def open_window(content, options)
    modal = options.delete(:modal)
    win = options.delete(:window)
    constraints = options.delete(:constraints)
    if(content.is_a?(Hash))
      if(content[:url])
        options[:url] = url_for(content[:url])
        content = nil
      else
        content = render(content)
      end
    end
    options[:width] ||= 300
    options[:height] ||= 200
    content = escape_javascript(content) if content
    win = escape_javascript(win) if win
    self << "var myWin = new Window({#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(', ')}});";
    unless(win.blank?)
      self << "Windows.registerByName('#{win}', myWin);"
    end
    if(content)
      self << "myWin.setHTMLContent('#{content}');"
    end
    unless(constraints == false)
      opts = {:left => 0, :right => 0, :top => 0, :bottom => 0}
      opts.merge!(constraints) if constraints.is_a?(Hash)
      self << "myWin.setConstraint(true, {#{opts.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(', ')}});"
    end
    self << "myWin.showCenter(#{modal ? 'true' : 'false'});"
  end
  
  # options:: Hash of options
  #   * :window -> name of window to close
  # Close the window of the provided name or the last opened window
  def close_window(options = {})
    win = options.delete(:window)
    win = escape_javascript(win) if win
    if(win)
      self << "Windows.getWindowByName('#{win}').close();"
    else
      self << "if(Windows.windows.values().last()){ Windows.windows.values().last().close(); }"
    end
  end
  
  # Close all open windows
  def close_all_windows
    self << "Windows.closeAll();"
  end
  
end

# Load everything into rails
if(defined? Rails)
  ActionView::Base.send :include, WindowRailsView
  ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send :include, WindowRailsGenerators
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'install.rb') # Always included in case we are gem'ed
end