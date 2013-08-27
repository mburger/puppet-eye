class Smtp < Eye::Checker::Custom
  param :username,  String
  param :password,  String
  param :server,    String
  param :ssl,       [TrueClass, FalseClass]
  param :timeout,   [Fixnum, Float]

  def initialize(*args)
    super

    @server   = (server   || ['127.0.0.1'])
    @port     = (port     || 25)
    @timeout  = (timeout  || 10)

    require 'net/smtp'
  end

  def check_name
    @check_name ||= "smtp(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        smtp = Net::Smtp.new(@server, @port)
        smtp.enable_tls if ssl
        smtp.start
        smtp.authenticate(username, password) if username && password
        { :result => smtp.finish }
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
    value
  end
end
