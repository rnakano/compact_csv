require 'csv'

class CompactCSV < CSV
  class Table < CSV::Table
    def initialize(array_of_rows, headers)
      super(array_of_rows)

      @headers = headers
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
  end

  class Row < CSV::Row
    def initialize(headers, fields, header_row = false)
      # @header_row = header_row

      # TODO: handle extra values
      @row_values = fields
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

