module Rspectacle
  class SpecRunner
    attr_accessor :files

    def initialize(files)
      self.files = files
    end

    def run
      raise "No Files Found" if files.empty?

      announce_files

      cmd = "bin/rspec #{files.join(' ')}"

      begin
        PTY.spawn( cmd ) do |stdout, stdin, pid|
          begin
            stdout.each do |line|
              next if line =~ /^cat\r\n$/
              print line
            end
          rescue Errno::EIO
            nil
          end
        end
      rescue PTY::ChildExited
        nil
      end
    end

    def announce_files
      puts ""
      puts "Running Specs:"
      files.each do |file|
        puts "* #{file}"
      end
      puts ""
    end
  end
end
