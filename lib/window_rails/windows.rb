require 'window_rails'

module WindowRails
  # Loads windowing helper methods into class
  module Windows

    def self.included(base)
      WindowRails::Generators.instance_methods(false).each do |method|
        base.class_eval do

          def _window_rails_holder
            @_window_rails_holder ||= WindowRails::Holder.new
          end

          define_method method do |*args|
            _window_rails_holder.context = self
            _window_rails_holder.send(method, *args)
            _window_rails_holder.window_flush.html_safe
          end

        end
      end

    end
  end
end

ActionView::Base.send(:include, WindowRails::Windows)
