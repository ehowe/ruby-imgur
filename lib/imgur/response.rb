class Imgur::Response
  class Error < StandardError
    attr_reader :response
    def initialize(response)
      @response = response
      super({status: response.status, headers: response.headers, body: response.body}.inspect)
    end
  end

  BadRequest    = Class.new(Error)
  NotFound      = Class.new(Error)
  Forbidden     = Class.new(Error)
  Unprocessable = Class.new(Error)

  EXCEPTION_MAPPING = {
    400 => BadRequest,
    403 => Forbidden,
    404 => NotFound,
    422 => Unprocessable,
  }

  attr_reader :headers, :status, :body

  def initialize(status, headers, body)
    @status, @headers, @body = status, headers, body
  end

  def successful?
    self.status.to_i < 300 && self.status.to_i > 199
  end

  def raise!
    if klass = EXCEPTION_MAPPING[self.status.to_i]
      raise klass.new(self)
    else self
    end
  end
end
