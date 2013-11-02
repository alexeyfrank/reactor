module Reactor
  module Streams
    class Server < Streams::Base
      def handle_read
        sock = @io.accept_nonblock
        emit(:accept, Stream.new(sock))
      end
    end
  end
end

