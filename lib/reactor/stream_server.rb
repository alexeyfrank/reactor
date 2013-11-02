module Reactor
  class StreamServer
    def initialize(io)
      @callbacks = {}
      @io = io
    end

    def to_io
      @io
    end

    def handle_read
      sock = @io.accept_nonblock
      emit(:accept, Stream.new(sock))
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
