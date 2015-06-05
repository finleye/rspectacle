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
      spec_files = convert_to_spec.select { |file| file =~ /_spec\.rb$/ }.uniq
      spec_files.select { |path| File.exist? path }
    end

    private

    def convert_to_spec
      files.each do |file_path|
        next if file_path =~ /^spec/
        in_app_path = app_paths.any? { |path| file_path =~ path }
        file_path.gsub!(/^app\//, "") if in_app_path
        file_path.gsub!(/\.rb$/, "_spec.rb")
        file_path.prepend "spec/"
      end
    end

    def app_paths
      [/\/controllers\//, /\/models\//, /\/views\//, /\/helpers\//, /\/workers\//,
       /\/policies\//, /\/presenters\//]
    end

    def reject_paths
    end
  end
end
