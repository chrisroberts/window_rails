require 'rails_javascript_helpers'

module WindowRails
  # Generator methods for dialogs
  module Generators

    include RailsJavaScriptHelpers
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper

    # Display alert dialog
    #
    # @param msg [String] message contents for dialog
    # @param options [Hash]
    # @option options [String] :title
    # @return [TrueClass]
    def open_alert_window(msg, options={})
      options[:content] = msg
      self << "window_rails.alert.open(#{format_type_to_js(options)});"
    end

    # Close the alert dialog
    #
    # @return [TrueClass]
    def close_alert_window
      self << 'window_rails.alert.close();'
      true
    end

    # Display confirmation dialog
    #
    # @param msg [String] message contents for dialog
    # @param options [Hash]
    # @option options [String] :title
    # @return [TrueClass]
    def open_confirm_window(msg, options={})
      options[:content] = msg
      self << "window_rails.confirm.open(#{format_type_to_js(options)});"
      true
    end

    # Close the confirm dialog
    #
    # @return [TrueClass]
    def close_confirm_window
      self << 'window_rails.confirm.close();'
      true
    end

    # Display information dialog
    #
    # @param msg [String] message contents for dialog
    # @param options [Hash]
    # @option options [String] :title
    # @return [TrueClass]
    def open_info_window(msg, options={})
      options[:content] = msg
      self << "window_rails.info.open(#{format_type_to_js(options)});"
      true
    end

    # Create a new window
    #
    # @param options [Hash]
    # @option options [String] :name name of window
    # @option options [String] :title title of window
    # @option options [String] :content content of window
    # @option options [String] :footer content of footer
    # @option options [String] :size size of window ('large' or 'small')
    # @option options [TrueClass, Falsey] :auto_open automatically open window (defaults true)
    # @return [TrueClass]
    def create_window(options={})
      self << "window_rails.create_window(#{format_type_to_js(options)});"
      if(options.fetch(:auto_open, true))
        self << "window_rails.open_window('#{options[:name]}', #{format_type_to_js(options)});"
      end
      true
    end

    # Open the window
    #
    # @param name [String] window name
    # @return [TrueClass]
    def open_window(name)
      self << "window_rails.open_window('#{name}');"
      true
    end

    # Close the window
    #
    # @param name [String] window name
    # @return [TrueClass]
    def close_window(name)
      self << "window_rails.close_window('#{name}');"
      true
    end

    # Update the contents of the window
    #
    # @param options [Hash]
    # @option options [String] :title title of window
    # @option options [String] :content content of window
    # @option options [String] :footer content of footer
    def update_window(name, options={})
      create_window(options.merge(:name => name, :show => false))
    end

    # Add popover support
    #
    # @param options [Hash]
    # @return [TrueClass]
    def popover(element, options={})
      self << "$('#{element}').popover(#{format_type_to_js(options)});"
      true
    end

  end
end
