#!/usr/bin/env ruby
$:.unshift(File.join(File.dirname(__FILE__)))
Dir.chdir File.join(File.dirname(__FILE__))

puts("\x1b[2J")
while(1) do
  system("passenger-status |grep 'PID\:' > /tmp/passenger-top.tmp")
  procs = []
  File.open("/tmp/passenger-top.tmp").each { |line|
     procs.push(line)
  }
  procs.sort!
  system("clear")
  puts("\x1b[0;0H")
  procs.each do |line|
    puts line
  end
  sleep(1)
end
