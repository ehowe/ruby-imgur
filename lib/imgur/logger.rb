class Imgur::Logger
  attr_reader :logger
  def initialize(app, logger)
    @app, @logger = app, logger
  end
  def call(env)
    request = Rack::Request.new(env)
    headers = env.keys.select{|k| k.match(/HTTP_/)}
    logger.debug { "--> #{request.request_method} #{request.url} #{request.params}\n#{headers.inject([]){|r,k| r + ["#{k.gsub("HTTP_", "")}: #{env[k].inspect}"]}.join("\n")}\n#{request.body.tap(&:rewind).read}" }
    request.body.tap(&:rewind)
    status, headers, body = @app.call(env)
    real_body = ""
    body.each{|b| real_body += b.to_s}
    logger.debug { "<-- #{status} #{request.url}\n#{headers.inject([]){|r,(k,v)| r + ["#{k.upcase}: #{v}"]}.join("\n")}\n#{real_body}" }
    [status, headers, body]
  rescue => e
    logger.error { "<-- #{e.inspect}" }
    raise
  end
end
