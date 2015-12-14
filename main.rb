require_relative 'compact_csv'

csv = CompactCSV.read('./sample.csv', headers: true)

p csv[1]


