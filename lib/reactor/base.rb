module Reactor
  class Base
    def initialize
      @callbacks = {}
    end

    def on(event, io, &callback)
      @callbacks[io] = callback
      # stream = Stream.new socket
      # yield stream
    end

    def run
      rs, ws = IO.select(@callbacks.keys, @callbacks.keys)
      rs.each do |s|
        @callbacks[s].call(Stream.new(s.accept_nonblock))
      end
    end
  end
end
