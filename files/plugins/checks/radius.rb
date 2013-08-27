class Radius < Eye::Checker::Custom
  param :username,  String, true
  param :password,  String, true
  param :secret,    String, true
  param :server,    String
  param :timeout,   [Fixnum, Float]

  def initialize(*args)
    super

    @server   = (server  || ['127.0.0.1'])
    @timeout  = (timeout || 5)

    require 'radiustar'
  end

  def check_name
    @check_name ||= "radius(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        req = Radiustar::Request.new(@server)
        { :result => req.authenticate(username, password, secret) }
      end
    rescue Timeout::Error
      { :exception => "Timeout<#{@timeout}>" }
    rescue Exception => e
      { :exception => "Error<#{e.message}>" }
    end
  end

  def human_value(value)
    if !value.is_a?(Hash)
      '-'
    elsif value[:exception]
      value[:exception]
    else
      value[:result]
    end
  end

  def good?(value)
    return false if !value[:result]
    value == true
  end
end
