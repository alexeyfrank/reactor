module Reactor
  module Streams
    class Stream < Streams::Base
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
end
