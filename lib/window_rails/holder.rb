require 'window_rails'

module WindowRails
  # Content container
  class Holder

    include WindowRails::Generators

    # @return [Context] current context
    attr_accessor :context

    # Create new instance
    #
    # @param args [Hash]
    # @option args [Context] :context
    def initialize(args={})
      @context = args[:context]
      @buffer = ''
    end

    # Add string to buffer
    #
    # @param string [String]
    # @return [self]
    def << (string)
      @buffer << string.to_s
      self
    end

    # Clear current buffer and return content
    #
    # @return [String]
    def window_flush
      buf = @buffer.dup
      @buffer = ''
      buf
    end

  end
end
