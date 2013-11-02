require 'socket'

module Reactor
  class Base
    def initialize
      @streams = []
      @stopped = false
    end

    def run
      tick while !@stopped

      if @stopped
        @streams.map &:close
      end
    end

    def tick
      rs, ws = IO.select(@streams, @streams)
      rs.each do |s|
        s.handle_read
      end

      ws.each do |s|
        s.handle_write
      end
    end

    def stop
      @stopped = true
    end

    def listen(host, port)
      server = Streams::Server.new(TCPServer.new(host, port))
      self << server
      server.on :accept do |stream|
        self << stream
      end
      server
    end

    def connect(host, port)
      socket = TCPSocket.new(host, port)
      stream = Streams::Stream.new socket
      self << stream
      stream
    end

    def <<(stream)
      @streams << stream
      stream.on :close do
        @streams.delete stream
      end
    end

  end
end
