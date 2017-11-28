# require 'sinatra'
# require 'json'

# get '/' do
#   status '200'
#   headers \
#     'Content-type'=> 'application/json'
#   body JSON.generate({:message => 'success'})
# end

class Server

  attr_accessor :server_wait_time
  # TODO: think about how I want this to work with a remote server
  def initialize(report=true, server_wait_time=3, server_path)
    @server_wait_time = server_wait_time
    @server_process = nil
    @reporting = report
    @server_path = server_path
  end

  def stop
    if @server_process.nil? || @server_process.closed?
      puts 'Server already stopped'
      false
    else
      Process.kill('TERM', @server_process.pid)
      Process.wait2 @server_process.pid
      @server_process = nil
      stop_reporting
      sleep @server_wait_time
      true
    end
  end

  def start
    if @server_process && !@server_process.closed?
      puts 'Server already running'
      false
    else
      path = File.expand_path("#{@server_path}")
      @server_process = Object::IO.popen "ruby #{path}"
      sleep @server_wait_time
      start_reporting
      true
    end

  end

  def status
    if @server_process && !@server_process.closed?
      'running'
    else
      'stopped'
    end
  end

  private

  #TODO - possible resource conflict, not thread safe?
  def start_reporting
    @reporting = Thread.new {
      while @report
        puts @server_process.readlines
      end
    }
  end

  def stop_reporting
    @reporting.kill
    @reporting = nil
  end


end