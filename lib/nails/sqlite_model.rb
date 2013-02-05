# lib/nails/sqlite_model.rb

require "sqlite3"
require "nails/util"

DB = SQLite3::Database.new "development.db"

module Nails
  module Model
    class SQLite

      def initialize(data = nil)
        @hash = data
      end

      def self.to_sql val
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL, are you trying something stupid?"
        end
      end

      def save!
        unless @hash["id"]
          self.class.create
          return true
        end

        fields = @hash.map do |key, value|
          "#{key}=#{self.class.to_sql(value)}"
        end.join ","

        DB.execute <<-SQL
        UPDATE #{self.class.table}
        SET #{fields}
        WHERE id = #{@hash["id"]}
        SQL
        true
      end

      def save
        self.save! rescue false
      end

      def self.create values
        values.delete "id"
        keys = schema.keys - ["id"]
        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) : "null"
        end

        DB.execute <<-SQL
        INSERT INTO #{table} (#{keys.join ","})
        VALUES (#{vals.join ","});
        SQL

        data = Hash[keys.zip vals]
        sql  = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        self.new data
      end

      def self.find id
        row = DB.execute <<-SQL
        SELECT #{schema.keys.join ","} from #{table}
        WHERE id = #{id};
        SQL

        data = Hash[schema.keys.zip row[0]]
        self.new data
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.count
        DB.execute(<<-SQL)[0][0]
        SELECT COUNT(*) FROM #{table}
        SQL
      end

      def self.table
        Rulers.to_underscore name
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info table do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end
    end
  end
end
