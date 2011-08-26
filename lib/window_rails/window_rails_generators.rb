require 'rails_javascript_helpers'

module WindowRailsGenerators

  include RailsJavaScriptHelpers
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
            .dialog(#{format_type_to_js(options)}).focus();
      }"
      nil
  end

  # Closes alert window
  def close_alert_window
    self << 'jQuery("#alert_modal").dialog("close");'
    nil
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
            .dialog(#{format_type_to_js(options)}).focus();
      }"
    nil
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
            .dialog(#{format_type_to_js(options)}).focus();
      }"
    nil
  end
  
  # Close an information window
  def close_info_window
    self << 'jQuery("#information_modal").dialog("close");'
    nil
  end
  
  # Update the contents of an information window
  def update_info_window(msg)
    self << 'jQuery("#information_modal").html(#{format_type_to_js(msg)});'
    nil
  end

  def window_setup
    @set ||= false
    unless(@set)
      self << '
        if(typeof(window.window_rails_windows) == "undefined") {
          window.window_rails_windows = {};
        } if(typeof(window_rails_windows_array) == "undefined") {
          window.window_rails_windows_array = new Array();
        }
        '
    end
    @set = true
    nil
  end

  def window(dom_id)
    window_setup
    unless(dom_id.blank?)
      dom_id = dom_id.to_s.dup
      dom_id.slice!(0) if dom_id.start_with?('#')
      self << "window.window_rails_windows['#{dom_id}']"
    else
      self << "window.window_rails_windows[window.window_rails_windows_array[0]]"
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
    self << check_for_window(win, error){ update_window_contents(key, win, options) }
    nil
  end
  
  # name:: Name of the window
  # error:: Will throw an alert if window is not found
  # Checks for a window of the given name. If a block is provided, it will be executed
  # if the window is found
  def check_for_window(name, error=true)
    name = name.to_s.dup
    name.slice!(0) if name.start_with?('#')
    window_setup
    if(name.blank?)
      self << "if(window.window_rails_windows.length > 0){"
    else
      self << "if(window.window_rails_windows['#{name}']){"
    end
    yield if block_given?
    self << "}"
    self << "else { alert('Unexpected error. Failed to locate window for output.'); }" if error
    nil
  end
  
  # key:: Content key location
  # win:: Name of window
  # Updates the contents of the window. If no window name is provided, the topmost window
  # will be updated
  def update_window_contents(key, win, options)
    window(win) << ".html(window.window_rails_contents[#{format_type_to_js(key.to_s)}]);"
    nil
  end

  # win:: Name of window
  # Will focus the window. If no name provided, topmost window will be focused
  def focus_window(win=nil)
    window(win) << '.dialog("focus");'
    nil
  end

  # win:: Name of window
  # Will maximize the window. If no name provided, topmost window will be maximized
  def maximize_window(win=nil)
    # noop
  end

  # win:: Name of window
  # Will minimize the window. If no name provided, topmost window will be minimized
  def minimize_window(win)
    # noop
  end

  # key:: Content key location
  # win:: Name of window
  # options:: Options to be passed onto window
  # Creates a new window. Generally this should not be called,
  # rather #open_window should be used
  # TODO: The below line causes an error in IE. Fix up to be compatible
  # so we aren't storing worthless junk:
  # window.window_rails_windows_array.splice(window.window_rails_windows_array.indexOf('#{win}'), 1);
  def create_window(key, win, options)
    options[:auto_open] ||= false
    options[:close] = "function(event,ui){ 
      #{
        if(options[:close])
          "callback = #{options[:close]}; callback();"
        end
      }
      jQuery('##{win}').dialog('destroy'); 
      window.window_rails_windows['#{win}'] = null;
      jQuery('##{win}').remove();
    }"
    unless(win.is_a?(String))
      win = win.to_s
    end
    if(win.start_with?('#'))
      win.slice!(0)
    end
    window_setup
    self << "
      if(jQuery('#window_rails_windows').size() == 0){
        jQuery('body').append('<div id=\"window_rails_windows\" style=\"visibility:hidden;display:none;\"></div>');
      }
      if(jQuery('##{win}').size() == 0){
        jQuery('#window_rails_windows').append('<div id=\"#{win}\"></div>');
      }
      window.window_rails_windows['#{win}'] = jQuery('##{win}');
      window.window_rails_windows_array.push('#{win}');
    "
    if(key == :url)
      options[:auto_open] = true
      self << "
        jQuery.get(
          '#{options.delete(:url)}',
          function(data){
            window.window_rails_windows['#{win}']
              .html(data)
                .dialog(#{format_type_to_js(options)})
                  .dialog('open');
          }
        );
      "
    else
      self << "
        window.window_rails_windows['#{win}']
          .html(window.window_rails_contents['#{key}'])
            .dialog(#{format_type_to_js(options)});
      "
    end
    nil
  end
  
  # win:: Name of window
  # modal:: True if window should be modal
  # Shows the window centered on the screen. If no window name is provided
  # it will default to the last created window. Generally this should not
  # be called, rather #open_window should be used
  # NOTE: No modal mode currently
  def show_window(win, modal)
    modal ||= false
    check_for_window(win) do
      window(win) << ".dialog('option', 'modal', #{format_type_to_js(modal)});"
      window(win) << ".dialog('option', 'autoOpen', true);"
      window(win) << '.dialog("open");'
    end
    nil
  end
  
  # content:: Content for window
  # options:: Hash of options
  #   * :modal -> Window should be modal
  #   * :window -> Name to reference window (used for easy updating and closing)
  #   * :constraints -> Hash containing top,left,right,bottom values for padding from edges. False value will turn off constraints (window can travel out of viewport)
  #   * :iframe -> URL to load within an IFrame in the window
  #   * :width -> Width of the window
  #   * :height -> Height of the window
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
    key = nil
    if(options[:iframe])
      iframe = @context.url_for(options.delete(:iframe))
    end
    if(content.is_a?(Hash))
      if(content[:url])
        options[:iframe] = @context.url_for(content[:url])
        content = nil
      elsif(content[:content_url])
        options[:url] = @context.url_for(content[:content_url])
        content = nil
      else
        content = @context.render(content)
      end
    end
    options[:width] ||= 300
    options[:height] ||= 200
    modal = options[:modal]
    if(options[:on_close])
      options[:close] = options.delete(:on_close)
    end
    if(options[:iframe])
      key = :iframe
    elsif(options[:url])
      key = :url
    else
      key = store_content(content)
    end
    win = options.delete(:window) || "win_#{rand(99999)}"
    if(options.delete(:no_update))
      create_window(key, win, options)
      show_window(win, modal)
    else
      check_for_window(win, false) do
        update_window_contents(key, win, options)
        focus_window(win)
      end
      else_block do
        create_window(key, win, options)
        show_window(win, modal)
      end
    end
    nil
  end

  def store_content(content, key=nil)
    unless(key)
      key = rand.to_s
      key.slice!(0,2)
    end
    c = content.is_a?(Hash) ? @context.render(content) : content.to_s
    self << "if(typeof(window.window_rails_contents) == 'undefined'){ window.window_rails_contents = {}; }"
    self << "window.window_rails_contents[#{format_type_to_js(key.to_s)}] = #{format_type_to_js(c)};"
    key
  end
  
  # options:: Hash of options
  #   * :window -> name of window to close
  # Close the window of the provided name or the last opened window
  def close_window(options = {})
    win_name = if(options.is_a?(Hash))
      [(options[:window] || options[:name]).to_s]
    elsif(options.is_a?(Array))
      options.map(&:to_s)
    else
      [options.to_s]
    end
    win_name.each do |win|
      window(win) << '.dialog("close");'
    end
  end
  
  # Close all open windows
  def close_all_windows
    setup_windows
    self << '
      jQuery.each(
        window_rails_windows_array,
        function(name, win){
          window.window_rails_windows[win].dialog("close");
        }
      );
    '
  end
  
  # args:: List of window names to refresh (All will be refreshed if :all is included)
  # Refresh window contents
  # NOTE: Currently does nothing
  # NOTE: Deprecated (remaining temporarily for compatibility reasons)
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
  # NOTE: Deprecated (remaining temporarily for compatibility reasons)
  def observe_dynamically_loaded_field(field_id, options={}) # :nodoc
    f = options.delete(:function)
    unless(f)
      f = "function(event){ new Ajax.Request('#{escape_javascript(@context.url_for(options[:url]).to_s)}', {asynchronous:true, evalScripts:true,parameters:'#{escape_javascript(options[:with].to_s)}='+$('#{escape_javascript(options[:with].to_s)}').getValue()})}"
    else
      f = "function(event){ #{f}; }"
    end
    self << "if($('#{escape_javascript(field_id.to_s)}')){ $('#{escape_javascript(field_id.to_s)}').observe('change', #{f}); }"
  end

  private

  # Simply wraps a block within an else statement
  def else_block
    self << "else {"
    yield if block_given?
    self << "}"
    nil
  end

end
ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods.send :include, WindowRailsGenerators
