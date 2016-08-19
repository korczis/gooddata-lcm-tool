# encoding: utf-8

require 'gooddata'

require_relative '../config'

def main()
  # Connect
  client = GoodData.connect($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false)

  projects = client.projects
  projects.peach do |project|
    puts "Deleting project '#{project.title}, PID: #{project.pid}'"

    begin
      project.delete
    rescue => e
      puts "Unable to delete project '#{project.title}', reason: #{e.message}"
    end
  end
end

# Entry point
if __FILE__ == $PROGRAM_NAME
  main
end
