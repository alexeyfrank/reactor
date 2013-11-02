class Stream
  def initialize(io)
    @io = io
  end

  def <<(data)
    @io.write_nonblock data
  end
end
