class Tftp < Eye::Checker::Custom
  param :server,    String
  param :file,      String, true
  param :timeout,   [Fixnum, Float]

  def initialize(*args)
    super

    @server   = (server   || ['127.0.0.1'])
    @timeout  = (timeout  || 10)

    require 'net/tftp'
  end

  def check_name
    @check_name ||= "tftp(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        io = StringIO.new
        tftp = Net::TFTP.new(@server)
        tftp.getbinary(file, io)
        { :result => io }
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
