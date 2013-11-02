require 'forwardable'

module Reactor
  module Streams
    class Base
      extend Forwardable

      attr_reader :io
      delegate [:close] => :io

      def initialize(io)
        @callbacks = {}
        @io = io
        @write_buffer = ''
      end

      def <<(chunk)
        @write_buffer << chunk
      end

      def to_io
        @io
      end

      def on(event, &callback)
        @callbacks[event] ||= []
        @callbacks[event] << callback
      end

      def emit(event, data)
        @callbacks[event].each do |cb|
          cb.call(data)
        end
      end
    end
  end
end
