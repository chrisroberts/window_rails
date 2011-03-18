module WindowRailsGenerators
  
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TagHelper
  
  # msg:: Alert message
  # options:: Hash of options values for the alert window
  # Opens an alert window
  def open_alert_window(msg, options={})
    options[:width] ||= 200
    options[:modal] = true
    options[:title] ||= 'Alert!'
    options[:buttons] ||= {'OK' => 'function(){ jQuery(this).dialog("close");}'}
    store_content(msg, 'alert_modal');
    self << "
      if(jQuery('#alert_modal').size() == 0){
        jQuery('<div id=\"alert_modal\"></div>')
          .html(window_rails_contents['alert_modal'])
            .dialog(#{format_type_to_js(options)});
      } else {
        jQuery('#alert_modal')
          .html(window_rails_contents['alert_modal'])
            .dialog(#{format_type_to_js(options)});
      }"
  end

  def close_alert_window
    self << 'jQuery("#alert_modal").dialog("close");'
  end

  # msg:: Confirmation message
  # options:: Hash of options values for the confirmation window
  # Opens a confirmation window
  def open_confirm_window(msg, options={})
    options[:width] ||= 200
    options[:modal] = true
    options[:title] ||= 'Confirm'
    options[:buttons] ||= {'OK' => 'function(){ jQuery(this).dialog("close");}'}
    store_content(msg, 'confirmation_modal')
    self << "
      if(jQuery('#confirmation_modal').size() == 0){
        jQuery('<div id=\"confirmation_modal\"></div>')
          .html(window_rails_contents['confirmation_modal'])
            .dialog(#{format_type_to_js(options)});
      } else {
        jQuery('#confirmation_modal')
          .html(window_rails_contents['confirmation_modal'])
            .dialog(#{format_type_to_js(options)});
      }"
  end
  
  # msg:: Information message
  # options:: Hash of options values for info window
  # Open an information window
  def open_info_window(msg, options={})
    options[:width] ||= 200
    options[:modal] = true
    options[:title] ||= 'Information'
    options[:close_on_escape] = false
    store_content(msg, 'information_modal')
    self << "
      if(jQuery('#information_modal').size() == 0){
        jQuery('<div id=\"information_modal\"></div>')
          .html(window_rails_contents['information_modal'])
            .dialog(#{format_type_to_js(options)});
      } else {
        jQuery('#information_modal')
          .html(window_rails_contents['information_modal'])
            .dialog(#{format_type_to_js(options)});
      }"
  end
  
  # Close an information window
  def close_info_window
    self << 'jQuery("#information_modal").dialog("close");'
  end
  
  # Update the contents of an information window
  def update_info_window(msg)
    self << 'jQuery("#information_modal").html(#{format_type_to_js(msg)});'
  end

  def window_setup
    self << '
      if(typeof(window_rails_mappings) == "undefined"){
        var window_rails_mappings = {};
      }'
  end

  def window(dom_id)
    window_setup
    unless(dom_id.blank?)
      dom_id = dom_id.to_s.dup
      dom_id.slice!(0) if dom_id.starts_with?('#')
      self << "jQuery.window.getWindow(window_rails_mappings[#{format_type_to_js(dom_id.to_s)}])"
    else
      self << 'jQuery.window.getAll().shift()'
    end
    self
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
    name = name.to_s.dup
    name.slice!(0) if name.starts_with?('#')
    if(name.blank?)
      self <<  "if(jQuery.window.getAll().length > 0){"
    else
      self << "if(jQuery.window.getWindow(#{format_type_to_js(name.to_s)})){"
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
    window(win) << ".setContent(window_rails_contents[#{format_type_to_js(key.to_s)}]);"
  end

  # win:: Name of window
  # Will focus the window. If no name provided, topmost window will be focused
  def focus_window(win=nil)
    window(win) << ".select();"
  end

  # win:: Name of window
  # Will maximize the window. If no name provided, topmost window will be maximized
  def maximize_window(win=nil)
    window(win) << ".maximize();"
  end

  # win:: Name of window
  # Will minimize the window. If no name provided, topmost window will be minimized
  def minimize_window(win)
    window(win) << ".minimize();"
  end

  # key:: Content key location
  # win:: Name of window
  # options:: Options to be passed onto window
  # Creates a new window. Generally this should not be called,
  # rather #open_window should be used
  def create_window(key, win, options)
    window_setup
    self << "
      win = jQuery.window(#{format_type_to_js(options)});
      window_rails_mappings[#{format_type_to_js(win.to_s)}] = win.getWindowId();
      win.setContent(window_rails_contents[#{format_type_to_js(key.to_s)}]);
    "
  end
  
  # win:: Name of window
  # modal:: True if window should be modal
  # Shows the window centered on the screen. If no window name is provided
  # it will default to the last created window. Generally this should not
  # be called, rather #open_window should be used
  # NOTE: No modal mode currently
  def show_window(win, modal)
    window(win) << ".show();"
  end
  
  # win:: Name of window
  # constraints:: Constaint hash {:left, :right, :top, :bottom}
  # Sets the constraints on the window. Generally this should not be used,
  # rather #open_window should be used
  # NOTE: Useless for now. Just constrains to the window
  def apply_window_constraints(win, constraints)
  return
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
    options[:check_boundary] = true
    if(content.is_a?(Hash))
      if(content[:url])
        options[:url] = @context.url_for(content[:url])
        content = nil
      else
        content = @context.render(content)
      end
    end
    options[:width] ||= 300
    options[:height] ||= 200
    key = store_content(content)
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

  def store_content(content, key=nil)
    unless(key)
      key = rand.to_s
      key.slice!(0,2)
    end
    c = content.is_a?(Hash) ? @context.render(content) : content.to_s
    self << "if(typeof(window_rails_contents) == 'undefined'){ var window_rails_contents = {}; }"
    self << "window_rails_contents[#{format_type_to_js(key.to_s)}] = #{format_type_to_js(c)}"
    key
  end
  
  # options:: Hash of options
  #   * :window -> name of window to close
  # Close the window of the provided name or the last opened window
  def close_window(options = {})
    window(options[:window]) << '.close();'
  end
  
  # Close all open windows
  def close_all_windows
    self << 'jQuery.window.closeAll();'
  end
  
  # args:: List of window names to refresh (All will be refreshed if :all is included)
  # Refresh window contents
  # NOTE: Currently does nothing
  def refresh_window(*args)
  return
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
  # NOTE: Currently does nothing
  def observe_dynamically_loaded_field(field_id, options={})
  return
    f = options.delete(:function)
    unless(f)
      f = "function(event){ new Ajax.Request('#{escape_javascript(@context.url_for(options[:url]).to_s)}', {asynchronous:true, evalScripts:true,parameters:'#{escape_javascript(options[:with].to_s)}='+$('#{escape_javascript(options[:with].to_s)}').getValue()})}"
    else
      f = "function(event){ #{f}; }"
    end
    self << "if($('#{escape_javascript(field_id.to_s)}')){ $('#{escape_javascript(field_id.to_s)}').observe('change', #{f}); }"
  end
  
  # arg:: Object
  # Does a simple transition on types from Ruby to Javascript.
  def format_type_to_js(arg)
    case arg
      when Array
        "[#{arg.map{|value| format_type_to_js(value)}.join(',')}]"
      when Hash
        "{#{arg.map{ |key, value|
          k = key.is_a?(Symbol) ? key.to_s.camelize.sub(/^./, key.to_s[0,1].downcase) : key.to_s
          "#{k}:#{format_type_to_js(value)}"
        }.join(',')}}"
      when Fixnum
        arg.to_s
      when TrueClass
        arg.to_s
      when FalseClass
        arg.to_s
      when NilClass
        'null'
      else
        arg.to_s =~ %r{^\s*function\s*\(} ? arg.to_s : "'#{escape_javascript(arg.to_s)}'"
    end
  end
end
ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send :include, WindowRailsGenerators
