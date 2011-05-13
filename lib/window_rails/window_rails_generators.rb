module WindowRailsGenerators
  
  include ActionView::Helpers::JavaScriptHelper
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
    self << "Dialog.confirm('#{escape_javascript(msg)}', {#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(',')}});"
  end
  
  # msg:: Information message
  # options:: Hash of options values for info window
  # Open an information window
  def open_info_window(msg, options={})
    options[:width] ||= 200
    self << "Dialog.info('#{escape_javascript(msg)}', {#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(',')}});"
  end
  
  # Close an information window
  def close_info_window
    self << "Dialog.closeInfo();"
  end
  
  # Update the contents of an information window
  def update_info_window(msg)
    self << "Dialog.setInfoMessage('#{escape_javascript(msg)}');"
  end
  
  # content:: content
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
    key = store_content(content)
    self << check_for_window(win, error){ update_window_contents(key, win) }
  end
  
  # name:: Name of the window
  # error:: Will throw an alert if window is not found
  # Checks for a window of the given name. If a block is provided, it will be executed
  # if the window is found
  def check_for_window(name, error=true)
    if(name.blank?)
      self <<  "if(Windows.windows.values().size() > 0){"
    else
      self << "if(Windows.existsByName('#{escape_javascript(name)}')){"
    end
    yield if block_given?
    self << "}"
    self << "else { alert('Unexpected error. Failed to locate window for output.'); }" if error
  end
  
  # Simply wraps a block within an else statement
  def else_block
    self << "else {"
    yield if block_given?
    self << "}"
  end
  
  # key:: Content key location
  # win:: Name of window
  # Updates the contents of the window. If no window name is provided, the topmost window
  # will be updated
  def update_window_contents(key, win=nil)
    unless(win.blank?)
      self << "Windows.getWindowByName('#{escape_javascript(win)}').setHTMLContent(window_rails_contents.get('#{key}'));"
    else
      self << "Windows.windows.values().last().setHTMLContent(window_rails_contents.get('#{key}'));"
    end
  end

  # win:: Name of window
  # Will focus the window. If no name provided, topmost window will be focused
  def focus_window(win=nil)
    unless(win.blank?)
      self << "Windows.focus(Windows.getWindowByName('#{escape_javascript(win)}').getId());"
    else
      self << "Windows.focus(Windows.windows.values().last().getId());"
    end
  end

  # win:: Name of window
  # Will maximize the window. If no name provided, topmost window will be maximized
  def maximize_window(win=nil)
    check_for_window(name) do
      if(name)
        self << "Windows.getWindowByName('#{escape_javascript(win)}').maximize();"
      else
        self << "Windows.windows.values().last().maximize();"
      end
    end
  end

  # win:: Name of window
  # Will minimize the window. If no name provided, topmost window will be minimized
  def minimize_window(win)
    check_for_window(name) do
      if(name)
        self << "Windows.getWindowByName('#{escape_javascript(win)}').minimize();"
      else
        self << "Windows.windows.values().last().minimize();"
      end
    end
  end

  # key:: Content key location
  # win:: Name of window
  # options:: Options to be passed onto window
  # Creates a new window. Generally this should not be called,
  # rather #open_window should be used
  def create_window(key, win, options)
    close_callback = options.delete(:setCloseCallback)
    self << "var myWin = new Window({#{options.map{|k,v|"#{escape_javascript(k.to_s)}:'#{escape_javascript(v.to_s)}'"}.join(', ')}});"
    self << "Windows.registerByName('#{escape_javascript(win)}', myWin);" unless win.blank?
    if(key.is_a?(Hash))
      self << "myWin.setAjaxContent('#{escape_javascript(key[:url])}');"
    else
      self << "myWin.setHTMLContent(window_rails_contents.get('#{key}'));"
    end
    if(close_callback)
      close_callback = close_callback.scan(/\{(.+)\}[^\}]*$/).try(:first).try(:first)
    end
    self << "myWin.setCloseCallback(function(win){ win.destroy(); #{close_callback} return true;});"
  end
  
  # win:: Name of window
  # modal:: True if window should be modal
  # Shows the window centered on the screen. If no window name is provided
  # it will default to the last created window. Generally this should not
  # be called, rather #open_window should be used
  def show_window(win, modal)
    s = nil
    unless(win.blank?)
      s = "Windows.getWindowByName('#{escape_javascript(win)}')"
    else
      s = 'Windows.windows.values().last()'
    end
    self << "#{s}.showCenter(#{modal ? 'true' : 'false'});"
  end
  
  # win:: Name of window
  # constraints:: Constaint hash {:left, :right, :top, :bottom}
  # Sets the constraints on the window. Generally this should not be used,
  # rather #open_window should be used
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
  #   * :modal -> Window should be modal
  #   * :window -> Name to reference window (used for easy updating and closing)
  #   * :constraints -> Hash containing top,left,right,bottom values for padding from edges. False value will turn off constraints (window can travel out of viewport)
  #   * :iframe -> URL to load within an IFrame in the window
  #   * :width -> Width of the window
  #   * :height -> Height of the window
  #   * :className -> Theme name for the window
  #   * :no_update -> Set to true to force creation of a new window even if window of same name already exists (defaults to false)
  # Creates a new window and displays it at the center of the viewport. Content can be provided as
  # a string, or as a Hash. If :url is defined, the window will be loaded with the contents of the request. If not, the hash
  # will be passed to #render and the string will be displayed.
  # Important note:
  #   There are two ways to load remote content. The first is to use :url => 'http://host/page.html' for content. This will
  #   load the contents directly into the window. The second is to set content to nil and pass :iframe => 'http://host/page.html'
  #   in the options. This later form will load the contents within an IFrame in the window. This is useful in that it will
  #   be isolated from the current page, but this isolation means it cannot communicate with other windows on the page (including
  #   its own).
  def open_window(content, options={})
    modal = options.delete(:modal)
    win = options.delete(:window)
    constraints = options.delete(:constraints)
    no_update = options.delete(:no_update)
    if(options[:on_close])
      options[:setCloseCallback] = options.delete(:on_close)
    end
    options[:className] = 'alphacube' unless options[:className]
    if(content.is_a?(Hash))
      if(content[:url])
        content[:url] = @context.url_for(content[:url])
      else
        content = @context.render(content)
      end
    end
    options[:width] ||= 300
    options[:height] ||= 200
    key = content.is_a?(Hash) ? content : store_content(content)
    if(no_update)
      create_window(key, win, options)
      unless(constraints == false)
        apply_window_constraints(win, constraints)
      end
      show_window(win, modal)
    else
      check_for_window(win, false) do
        update_window_contents(key, win)
        focus_window(win)
      end
      else_block do
        create_window(key, win, options)
        unless(constraints == false)
          apply_window_constraints(win, constraints)
        end
        show_window(win, modal)
      end
    end
  end

  def store_content(content)
    key = rand.to_s
    key.slice!(0,2)
    c = content.is_a?(Hash) ? @context.render(content) : content.to_s
    self << "if(typeof(window_rails_contents) == 'undefined'){ var window_rails_contents = new Hash(); }"
    self << "window_rails_contents.set('#{key}', '#{escape_javascript(c)}')"
    key
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
  
  # field_id:: DOM ID of form element to observe
  # options:: Options
  # Helper for observing fields that have been dynamically loaed into the DOM. Works like
  # #observe_field but not as full featured. 
  def observe_dynamically_loaded_field(field_id, options={})
    f = options.delete(:function)
    unless(f)
      f = "function(event){ new Ajax.Request('#{escape_javascript(@context.url_for(options[:url]).to_s)}', {asynchronous:true, evalScripts:true,parameters:'#{escape_javascript(options[:with].to_s)}='+$('#{escape_javascript(options[:with].to_s)}').getValue()})}"
    else
      f = "function(event){ #{f}; }"
    end
    self << "if($('#{escape_javascript(field_id.to_s)}')){ $('#{escape_javascript(field_id.to_s)}').observe('change', #{f}); }"
  end
  
end
