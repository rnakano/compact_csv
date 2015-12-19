require 'csv'

class CompactCSV < CSV

  VERSION = "0.0.1"

  class Table < CSV::Table
    def initialize(array_of_rows, headers)
      super(array_of_rows)

      @headers = headers
      @headers_map = {}
      @headers.each_with_index do |str, i|
        @headers_map[str] = i
      end
      link_table_headers
    end

    def link_table_headers
      @table.each do |row|
        row.link_table(self)
      end
    end

    def headers
      @headers
    end

    def index_by_header(str)
      @headers_map[str]
    end
  end

  class Row < CSV::Row
    def initialize(headers, fields, header_row = false)
      # @header_row = header_row

      # TODO: handle extra values
      @row_values = fields
    end

    def headers
      @table.headers
    end

    def link_table(table)
      @table = table
    end

    def row
      @table.headers.zip(@row_values).to_a
    end

    def each(&block)
      row.each(&block)
      self
    end

    def fields(*headers_and_or_indices)
      if headers_and_or_indices.empty?
        @row_values
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
        i = @table.index_by_header(index)
        i ? @row_values[i] : nil
      end
    end
    alias_method :field, :[]

    def []=(index, value)
      if index.is_a?(Integer)
        @row_values[index] = value
      else
        i = @table.index_by_header(index)
        @row_values[i] = value if i
      end
    end
  end

  def read
    rows = to_a
    if @use_headers
      CompactCSV::Table.new(rows, @headers)
    else
      rows
    end
  end
end
