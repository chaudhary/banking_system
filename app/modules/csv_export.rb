require 'csv'

class ::CsvExport

  def initialize(filename = nil)
    @filename = filename || 'csv_file'
    @header_row = []
    @other_rows = []
  end

  def export_data(data)
    new_headers = data.keys - @header_row
    @header_row += new_headers

    row = []
    @header_row.each do |header|
      row << data[header]
    end
    @other_rows << row
  end

  def build
    filepath = Rails.root.join("tmp/#{@filename}.csv")
    data_file = CSV.open(filepath, 'w')
    data_file << @header_row
    @other_rows.each do |other_row|
      data_file << other_row
    end
    data_file.close
    return filepath
  end
end
