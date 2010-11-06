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
  #   * error -> Show error if window is not found (defaults false)
  # Updates the window with the new content. If the content is a string, it will
  # be placed into the window. If it is a Hash, it will be fed to render and the
  # result will be placed in the window (basically an easy way to integrate partials:
  # page.update_window(:partial => 'my_parital'))
  def update_window(content, options={})
    win = options.delete(:window)
    error = options.delete(:error)
    if(content.is_a?(Hash))
      content = render(content)
    end
    self << check_for_window(win, error){ update_window_contents(content, win) }
  end
  
  def check_for_window(name, error)
    if(name.blank?)
      self <<  "if(Windows.windows.values().size() > 0){"
    else
      self << "if(Windows.existsByName('#{escape_javascript(name)}')){"
    end
    self << yield if block_given?
    self << "}"
    self << "else { alert('Unexpected error. Failed to locate window for output.'); }" if error
  end
  
  def else_block
    self << "else {"
    self << yield if block_given?
    self << "}"
  end
  
  def update_window_contents(content, win)
    unless(win.blank?)
      self << "Windows.getWindowByName('#{escape_javascript(win)}').setHTMLContent('#{escape_javascript(content)}');"
    else
      self << "Windows.window.values().last().setHTMLContent('#{escape_javascript(content)}');"
    end
  end

  def focus_window(win)
    unless(win.blank?)
      self << "Windows.focus(Windows.getWindowByName('#{escape_javascript(win)}').getId());"
    else
      self << "Windows.focus(Windows.windows.values().last().getId());"
    end
  end

  def create_window(content, win, options)
    self << "var myWin = new Window({#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(', ')}});"
    self << "Windows.registerByName('#{escape_javascript(win)}', myWin);" unless win.blank?
    self << "myWin.setHTMLContent('#{escape_javascript(content)}');" unless content.blank?
    self << "myWin.setCloseCallback(function(win){ win.destroy(); return true; });"
  end
  
  def show_window(win, modal)
    s = nil
    unless(win.blank?)
      s = "Windows.getWindowByName('#{escape_javascript(win)}')"
    else
      s = 'Windows.windows.values().last()'
    end
    self << "#{s}.showCenter(#{modal ? 'true' : 'false'});"
  end
  
  def apply_window_constraints(win, constraints)
    opts = {:left => 0, :right => 0, :top => 0, :bottom => 0}
    opts.merge!(constraints) if constraints.is_a?(Hash)
    s = nil
    unless(win.blank?)
      s = "Windows.getWindowByName('#{escape_javascript(win)}')"
    else
      s = "Windows.windows.values().last()"
    end
    self << "#{s}.setConstraint(true, {#{opts.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(', ')}});"
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
  #   * no_update -> Set to true to force creation of a new window even if window of same name already exists (defaults to false)
  # Creates a new window and displays it at the center of the viewport.
  def open_window(content, options)
    modal = options.delete(:modal)
    win = options.delete(:window)
    constraints = options.delete(:constraints)
    no_update = options.delete(:no_update)
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
    output = []
    if(no_update)
      create_window(content, win, options)
      apply_window_constraints(win, constraints) unless constraints == false
      show_window(win, modal)
    else
      check_for_window(win, false) do
        update_window_contents(content, win)
        focus_window(win)
      end
      else_block do
        create_window(content, win, options)
        apply_window_constraints(win, constriants) unless constraints == false
        show_windw(win, modal)
      end
    end
  end
  
  # options:: Hash of options
  #   * :window -> name of window to close
  # Close the window of the provided name or the last opened window
  def close_window(options = {})
    win = options.is_a?(Hash) ? options.delete(:window) : options.to_s
    self << "var myWin = null;"
    unless(win.blank?)
      self << "myWin = Windows.getWindowByName('#{escape_javascript(win)}');"
    else
      self << "if(Windows.windows.values().last()){ myWin = Windows.windows.values().last(); }"
    end
    self << "if(myWin){ myWin.close(); }"
  end
  
  # Close all open windows
  def close_all_windows
    self << "Windows.closeAll();"
  end
  
  # args:: List of window names to refresh (All will be refreshed if :all is included)
  # Refresh window contents
  def refresh_window(*args)
    self << "var myWin = null;"
    if(args.include?(:all))
      self << "Windows.windows.values().each(function(win){ win.refresh(); });"
    else
      args.each do |win|
        self << "myWin = Windows.getWindowByName('#{escape_javascript(win.to_s)}');"
        self << "if(myWin){ myWin.refresh(); }"
      end
    end
  end
  
end