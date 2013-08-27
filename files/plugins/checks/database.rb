class Database < Eye::Checker::Custom
  param :server,    String
  param :username,  String, true
  param :password,  String, true
  param :db,        String, true
  param :db_type,   String, true
  param :table,     String, true
  param :timeout,   [Fixnum, Float]

  def initialize(*args)
    super

    @server   = (server  || ['127.0.0.1'])
    @timeout  = (timeout || 10)

    require 'active_record'
  end

  def check_name
    @check_name ||= "dns(#{human_value(domain)})"
  end

  def get_value
    begin
      Timeout::timeout(@timeout) do
        ActiveRecord::Base.establish_connection(
          :adapter  => db_type,
          :database => db,
          :username => username,
          :password => password,
          :host     => @server
        )
        unless @db_table
          @db_table = Object.const_set(table.capitalize, Class.new(ActiveRecord::Base))
          @db_table.send(:set_table_name, table)
        end
        { :result => @db_table.first }
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
    value.valid?
  end
end
