require 'forwardable'

module Reactor
  class Stream
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

    def handle_read
      chunk = @io.read_nonblock(4096)
      emit(:data, chunk)
    rescue EOFError, Errno::ECONNRESET
      # IO was closed
      emit(:close)
    end

    def handle_write
      return if @write_buffer.empty?
      length = @io.write_nonblock(@write_buffer)
      # Remove the data that was successfully written.
      @write_buffer.slice!(0, length)
    rescue EOFError, Errno::ECONNRESET
      emit(:close)
    end
  end
end
