require 'json'

module DAT
  class Version

    class << self

      def instance
        @instance ||= new
      end
      def to_s
        instance.to_hash.values.join '.'
      end

      def to_hash
        instance.to_hash
      end

      def set_version(major:, minor:, patch:)
        instance.set_version major: major, minor: minor, patch: patch
      end

      def increment_major
        instance.increment_major
      end

      def increment_minor
        instance.increment_minor
      end

      def increment_patch
        instance.increment_patch
      end

    end



    attr_accessor :major, :minor, :patch

    def initialize(path: File.absolute_path(File.join(__dir__,'./data/version.json')))
      @path = path
      load_version file_path: @path
    end

    def to_s
      to_hash.values.join '.'
    end

    def to_hash
      {major: @major, minor: @minor, patch: @patch}
    end

    def set_version(major:, minor:, patch:)
      @major, @minor, @patch = major.to_i, minor.to_i, patch.to_i
      save_version file_path: @path
    end

    def increment_major
      increment segment: :major
    end

    def increment_minor
      increment segment: :minor
    end

    def increment_patch
      increment segment: :patch
    end

    private

    def increment(segment:, value: 1)

      case segment
      when :major
        @major += value
        @minor = 0
        @patch = 0
      when :minor
        @minor += value
        @patch = 0
      when :patch
        @patch +=value
      end
      save_version file_path: @path
      to_s
    end

    def load_version(file_path:)
      if File.file? file_path
        JSON.parse(File.read(file_path), symbolize_names: true).each do| vn, value|
          send("#{vn}=", value)
        end
      else
        @major, @minor, @patch = 1,0,0
      end
    end

    def save_version(file_path:)
      file = File.open(file_path, 'w+')
      file.puts(JSON.pretty_generate(to_hash))
      file.close
    end
  end
end