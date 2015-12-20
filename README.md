# CompactCSV

[![Build Status](https://travis-ci.org/rnakano/compact_csv.svg?branch=master)](https://travis-ci.org/rnakano/compact_csv)
[![Coverage Status](https://coveralls.io/repos/rnakano/compact_csv/badge.svg?branch=master&service=github)](https://coveralls.io/github/rnakano/compact_csv?branch=master)
[![Dependency Status](https://gemnasium.com/rnakano/compact_csv.svg)](https://gemnasium.com/rnakano/compact_csv)

CompactCSV is memory efficient csv module for ruby. Reading operations are compatible with default CSV module.

However, operations which change fields/values structure of row are not available in CompactCSV. If you want to do this, please use default CSV module.

## Installation

Add this line to your application's Gemfile:

    gem 'compact_csv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compact_csv

## Usage

```ruby
csv = CompactCSV.read('sample.csv', headers: true)
csv.each do |row|
  p row # => #<CompactCSV::Row "ID":"1" "VALUE":"A">
  row['VALUE'] = 'AAA'
  p row # => #<CompactCSV::Row "ID":"1" "VALUE":"AAA">
end
```

## Links

* ruby default CSV module: https://github.com/ruby/ruby/blob/trunk/lib/csv.rb

## Contributing

1. Fork it ( http://github.com/rnakano/compact_csv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
