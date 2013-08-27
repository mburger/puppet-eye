class Imap < Eye::Checker::Custom
  param :username,  String, true
  param :password,  String, true
  param :server,    String
  param :timeout,   [Fixnum, Float]

  def initialize(*args)
    super

    @server   = (server  || ['127.0.0.1'])
    @timeout  = (timeout || 10)

    require 'net/imap'
  end

  def check_name
    @check_name ||= "imap(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        imap = Net::IMAP.new(@server)
        imap.login(username, password)
        imap.examine('INBOX')
        { :result => imap.fetch((imap.search(['UNSEEN']).empty? ? 1 : imap.search(['UNSEEN'])[0].to_i), 'BODY') }
      end
    rescue Timeout::Error
      { :exception => "Timeout<#{@timeout}>" }
    rescue Exception => e
      { :exception => "Error<#{e.message}>" }
    ensure
      imap.disconnect unless imap.disconnected?
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
