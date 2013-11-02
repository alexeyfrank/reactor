require 'test_helper'

class ReactorTest < MiniTest::Test
  def setup
    @hello_msg = "hello\n"

    server = TCPServer.new "localhost", 8080
    @client = TCPSocket.new "localhost", 8080
    @client << @hello_msg

    Reactor.run do |reactor|
      reactor.on(:accept, server) do |stream|
        stream << @hello_msg
      end
    end

  end

  def test_run
    response = @client.gets
    assert { @hello_msg == response }
  end
end
