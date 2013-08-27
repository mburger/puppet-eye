class Dns < Eye::Checker::Custom
  param :domain,          String, true
  param :domain_address,  String, true
  param :server,          [String, Array]
  param :timeout,         [Fixnum, Float]

  def initialize(*args)
    super
    require 'resolv'

    @server   = (server  || ['127.0.0.1'])
    @timeout  = (timeout || 5)
  end

  def check_name
    @check_name ||= "dns(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        resolver = Resolv::DNS.new(:nameserver => @server)
        { :result => resolver.getaddress(domain).to_name.to_s }
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
    value[:result] == domain_address
  end
end
