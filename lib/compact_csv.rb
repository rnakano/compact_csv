require 'csv'

class CompactCSV < CSV
  require_relative 'compact_csv/version'

  class Table < CSV::Table
  end

  class Row < CSV::Row
    def initialize(headers, fields, header_row = false)
      @headers = headers
      @row_values = fields
    end

    def headers
      @headers
    end

    def row
      headers.zip(@row_values).to_a
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
        size_diff = headers.size - @row_values.size
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
      @row_values.size
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
