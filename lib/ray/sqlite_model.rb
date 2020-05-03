require "sqlite3"
require "ray/util"

DB = SQLite3::Database.new "ray.db"

module Ray
  module Model
    class SQLite
      def initialize(data = {})
        @hash = data
      end

      def self.find(id)
        row = DB.execute <<~SQL
          SELECT #{schema.keys.join(", ")} FROM #{table} WHERE id = #{id};
        SQL

        data = Hash[schema.keys.zip(row[0])]
        self.new(data)
      end

      def self.create(values)
        values.delete("id")
        keys = schema.keys - ["id"]

        converted_values = keys.map do |key|
          values[key] ? to_sql(values[key]) : "null"
        end

        DB.execute <<~SQL
          INSERT INTO #{table} (#{keys.join(", ")}) VALUES (#{converted_values.join(", ")});
        SQL

        raw_vals = keys.map { |k| values[k] }
        data = Hash[keys.zip(raw_vals)]
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        self.new(data)
      end

      def self.count
        sql = "SELECT COUNT(*) FROM #{table};"
        DB.execute(sql)[0][0]
      end

      def save
        self.save! rescue false
      end

      def save!
        unless @hash["id"]
          self.class.create(@hash)
          return true
        end

        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end.join(", ")

        DB.execute <<~SQL
          UPDATE #{self.class.table} SET #{fields} WHERE id = #{@hash["id"]}
        SQL
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.to_sql(val)
        case val
        when NilClass
          "null"
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

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
