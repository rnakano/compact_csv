require 'spec_helper'

describe CompactCSV do
  it 'should have a version number' do
    expect(CompactCSV::VERSION).not_to be nil
  end

  it 'loads csv without error' do
    csv_path = './spec/data/sample.csv'
    csv = CompactCSV.read(csv_path, headers: true)
    expect(csv).to be_truthy
  end
end
