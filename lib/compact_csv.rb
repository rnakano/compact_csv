require 'csv'

class CompactCSV < CSV
  require_relative 'compact_csv/version'

  class CompatibilityError < StandardError
  end

  class Table < CSV::Table
  end

  class Row < CSV::Row
    def initialize(headers, fields, header_row = false)
      headers.freeze
      @headers = headers
      @row_values = fields
    end

    def headers
      @headers
    end

    def row
      if @headers.size >= @row_values.size
        @headers.zip(@row_values).to_a
      else
        @row_values.zip(@headers).map { |pair| pair.reverse! }
      end
    end

    def header_row?
      false
    end

    def each(&block)
      row.each(&block)
      self
    end

    def fields(*headers_and_or_indices)
      if headers_and_or_indices.empty?
        size_diff = @headers.size - @row_values.size
        if size_diff <= 0
          @row_values
        elsif size_diff > 0
          @row_values + Array.new(size_diff, nil)
        end
      else
        headers_and_or_indices.map do |index|
          field(index)
        end
      end
    end

    def size
      [ @row_values.size, @headers.size ].max
    end
    alias_method :length, :size

    def empty?
      @row_values.empty?
    end

    def fetch(header, *varargs)
      raise ArgumentError, "Too many arguments" if varargs.length > 1
      pair = row.assoc(header)
      if pair
        pair.last
      else
        if block_given?
          yield header
        elsif varargs.empty?
          raise KeyError, "key not found: #{header}"
        else
          varargs.first
        end
      end
    end

    def has_key?(header)
      !!row.assoc(header)
    end

    def [](index)
      if index.is_a?(Integer)
        @row_values[index]
      else
        i = headers.find_index(index)
        i ? @row_values[i] : nil
      end
    end
    alias_method :field, :[]

    def []=(index, value)
      if index.is_a?(Integer)
        @row_values[index] = value
      else
        i = headers.find_index(index)
        @row_values[i] = value if i
      end
    end

    def to_hash
      hash = {}
      @row_values.zip(headers) do |value, row|
        hash[row] = value
      end
      hash
    end

    def ==(other)
      return row == other.row if other.is_a? CompactCSV::Row
      row == other
    end

    # not compatible methods
    def <<(arg)
      raise CompatibilityError.new("CompactCSV does not allow to append fields into row. Please use CSV module.")
    end

    def push(*args)
      raise CompatibilityError.new("CompactCSV does not allow to append fields into row. Please use CSV module.")
    end

    def delete(header_or_index, minimum_index = 0)
      raise CompatibilityError.new("CompactCSV does not allow to delete fields from row. Please use CSV module.")
    end

    def delete_if(&block)
      raise CompatibilityError.new("CompactCSV does not allow to delete fields from row. Please use CSV module.")
    end
  end

  def read
    rows = to_a
    if @use_headers
      CompactCSV::Table.new(rows)
    else
      rows
    end
  end
end

def CompactCSV(*args, &block)
  CompactCSV.instance(*args, &block)
end
