require 'sinatra'
require 'json'

before do
  # if request.body
    request.body.rewind
    @request_payload = request.body.read
  # end
end

get '/' do
  puts params
  status '200'
  headers 'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success', params: params})
end

post '/' do
  status '200'
  headers 'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success', payload: JSON.parse(@request_payload)})
end

put '/' do
  status '200'
  headers 'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success', payload: JSON.parse(@request_payload)})
end

patch '/' do
  status '200'
  headers 'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success', payload: JSON.parse(@request_payload)})
end

delete '/:id' do |id|
  status '200'
  headers 'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success', id: id})
end

class Server

  attr_accessor :server_wait_time
  def initialize(server_path = nil, report=false, server_wait_time=3)
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
      path = ''
      if @server_path
        path = File.expand_path("#{@server_path}")
      else
        path = File.dirname(__FILE__) + '/stub_server.rb'
      end

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