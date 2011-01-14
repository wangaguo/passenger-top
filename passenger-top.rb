#!/usr/bin/env ruby
$:.unshift(File.join(File.dirname(__FILE__)))
Dir.chdir File.join(File.dirname(__FILE__))

domain = ""
if ARGV[0] =~ /-h/
  puts <<-EOS
Usage: passenger-top [options]

passenger-top is like unix top command for passenger

Options:
        --domain=parts_of_domain_path
  EOS
  exit
end
if ARGV[0] =~ /^domain=(.*)/
  domain = $1
end

begin
  print "\x1b[?25l" #Cursor invisible
  while(1) do
    infos = [] #infomation data
    domains = [] #domains data
    type = "" #set section type
    i = -1

    hr = `passenger-status`
    lines = hr.split(/\n/)

    #Process passenger-status data
    lines.each{|line|
      if line =~ /information/
        type = "info"
        next
      elsif line =~ /Domains/
        type = "domain"
        next
      end
      if type == "info"
        infos << line.gsub(/\s+/, " ") if line =~ /[:=]/
      elsif type == "domain"

        if line =~ /^(\/.*)$/ #domain path
          i+=1
          domains[i] = {}
          domains[i][:name] = line
          domains[i][:data] = []
          next
        elsif line =~ /PID/ #Process data
          domains[i][:data] << line
        end

      end
    }

    print("\x1b[2J\x1b[1;1H") # Erase all screen && Move cursor to 1,1. (VT100 escape codes) #equals system("clear")
    #diaplay data on screen
    infos.each{|x|
      print x+"; "
    }
    print "\n\n"
    domains.each{|p|
      if domain == "" or p[:name] =~ Regexp.compile(domain)
        puts "\x1b[34m#{p[:name]}\x1b[0m"
        p[:data].sort!.each{|pid| puts pid}
        puts ""
      end
    }

    sleep(1)
  end
rescue Interrupt => e
  print "\x1b[?25h" #Cursor visible
  print "\x1b[2K\x1b[2D" #Clear line & Cursor move left 2. For '^C' String.
  exit
end