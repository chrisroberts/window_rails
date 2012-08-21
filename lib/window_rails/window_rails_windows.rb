require 'window_rails/window_rails_generators'

module WindowRails
  class Holder
    include WindowRailsGenerators

    attr_accessor :context

    def initialize(args={})
      @context = args[:context]
      @buffer = ''
    end

    def << (string)
      @buffer << string.to_s
    end

    def window_flush
      buf = @buffer.dup
      @buffer = ''
      buf
    end
  end
end

module WindowRails
  module Windows
    def self.included(base)
      WindowRailsGenerators.instance_methods(false).each do |method|
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
