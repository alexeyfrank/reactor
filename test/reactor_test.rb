require 'test_helper'

class ReactorTest < MiniTest::Test
  def test_echo
    @hello_msg = "hello"

    Reactor.run do |reactor|
      server = reactor.listen("localhost", 8080)
      server.on :accept do |stream|
        stream.on :data do |data|
          stream << data
        end
      end

      client_stream = reactor.connect("localhost", 8080)
      client_stream.on :data do |data|
        assert { @hello_msg == data }
        reactor.stop
      end

      client_stream << @hello_msg
    end
  end

  def test_ping_pong
    Reactor.run do |reactor|
      server = reactor.listen("localhost", 8080)
      server.on :accept do |stream|
        stream.on :data do |data|
          puts data
          stream << 'pong'
        end
      end

      client_stream = reactor.connect("localhost", 8080)
      client_stream.on :data do |data|
        puts data
        client_stream << 'ping'
      end

      client_stream << 'ping'
    end
  end
end
