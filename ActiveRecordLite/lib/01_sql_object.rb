require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns unless @columns.nil?
    table_columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @columns = table_columns.first.map(&:to_sym)
  end

  def self.finalize!

    columns.each do |attr|

      attr_str = attr.to_s

      define_method(attr_str) do
        @attributes[attr]
      end

      define_method(attr_str+'=') do |value|
        @attributes = Hash.new unless @attributes
        @attributes[attr] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    row_hashes = DBConnection.execute(<<-SQL)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL

    parse_all(row_hashes)
  end

  def self.parse_all(results)
    results.map {|row| self.new(row)}
  end

  def self.find(id)
    object = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL
    parse_all(object).first
  end

  def initialize(params = {})
    params.each do |k, v|
      raise "unknown attribute '#{k.to_s}'" unless self.class.columns.include?(k.to_sym)
      send(k.to_s + "=", v)
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    attributes.values
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
