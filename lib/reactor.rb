require "reactor/version"

module Reactor
  autoload :Base, 'reactor/base'
  autoload :Stream, 'reactor/stream'
  # Your code goes here...
  def self.run
    reactor = Base.new
    yield reactor
    reactor.run
  end
end
