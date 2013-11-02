require "reactor/version"

module Reactor
  autoload :Base, 'reactor/base'
  module Streams
    autoload :Base, 'reactor/streams/base'
    autoload :Stream, 'reactor/streams/stream'
    autoload :Server, 'reactor/streams/server'
  end
  # Your code goes here...
  def self.run
    reactor = Base.new
    yield reactor
    reactor.run
  end
end
