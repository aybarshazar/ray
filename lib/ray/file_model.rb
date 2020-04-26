require "multi_json"

module Ray
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/#{id}.json")
        rescue
          nil
        end
      end

      def self.all
        files = Dir.glob("db/*.json")
        files.map { |f| FileModel.new(f) }
      end
    end
  end
end
