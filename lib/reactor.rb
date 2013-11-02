require "reactor/version"

module Reactor
  autoload :Base, 'reactor/base'
  autoload :Stream, 'reactor/stream'
  autoload :StreamServer, 'reactor/stream_server'
  # Your code goes here...
  def self.run
    reactor = Base.new
    yield reactor
    reactor.run
  end

end
