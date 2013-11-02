require 'bundler'
Bundler.require

Wrong.config.color
MiniTest.autorun

require 'socket'

class MiniTest::Test
  include Wrong
end
