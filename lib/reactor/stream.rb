class Stream
  def initialize(io)
    @callbacks = {}
    @io = io
  end

  def <<(data)
    @io.write_nonblock data
  end

  def to_io
    @io
  end

  def handle_read 
    data = @io.read_nonblock(4096)
    emit(:data, data)
  end

  def on(event, &callback)
    @callbacks[event] ||= []
    @callbacks[event] << callback
  end

  def emit(event, data)
    @callbacks[event].each do |cb|
      cb.call(data)
    end
  end
end
