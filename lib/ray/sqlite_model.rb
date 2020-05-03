require "sqlite3"
require "ray/util"

DB = SQLite3::Database.new "ray.db"

module Ray
  module Model
    class SQLite
      def self.table
        Ray.to_underscore(name)
      end

      def self.schema
        return @schema if @schema

        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end
    end
  end
end
