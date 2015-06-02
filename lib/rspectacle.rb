require "hashie"
require "haml"
require "pty"
require "pry"

require "rspectacle/version"

module Rspectacle
  class FileGather
    attr_accessor :files

    def initialize
      self.files = get_staged_files
    end

    def get_staged_files
      `git status --porcelain | cut -c4-`.split("\n")
    end

    def specs_to_run
      spec_files = convert_to_spec.select{|file| file =~ /_spec\.rb$/}.uniq
      spec_files.select{|path| File.exist? path}
    end

    private

    def convert_to_spec
      files.each do |file_path|
        next if file_path =~ /^spec/
        in_app = app_paths.any? { |path| file_path =~ path}
        file_path.gsub!(/^app\//, "") if in_app
        file_path.gsub!(/\.rb$/, '_spec.rb')
        file_path.prepend "spec/"
      end
    end

    def app_paths
      [/\/controllers\//, /\/models\//, /\/views\//, /\/helpers\//, /\/workers\//, /\/policies\//]
    end

    def reject_paths
    end
  end

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
