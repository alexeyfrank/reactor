module Reactor
  class StreamServer < Stream
    def handle_read
      sock = @io.accept_nonblock
      emit(:accept, Stream.new(sock))
    end
  end
end
