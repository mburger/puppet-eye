class Opentsdb < Eye::Trigger::Custom
  param :server,  String, true
  param :port,    String, true
  param :timeout, [Float, Fixnum]

  def initialize(*args)
    super
    @timeout = (timeout || 10)
    @hostname = `hostname --fqdn`.strip
  end

  def check(transition)
    begin
      Timeout::timeout(@timeout) do
        if !@client || @client.closed?
          @client = OpenTSDB::Client.new(:hostname => server, :port => port)
        end
        value = (transition.event != :up) ? 1 : 0
        sample = { :metric => 'eye.restart.count', :value => value, :timestamp => Time.now.to_i, :tags => {:host => @hostname } }
        @client.put(sample)
      end
    rescue Exception
    end
  end
end
