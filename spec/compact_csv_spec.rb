require 'spec_helper'

describe CompactCSV do
  it 'should have a version number' do
    expect(CompactCSV::VERSION).not_to be nil
  end

  describe '.read' do
    let(:csv_path) { './spec/data/sample.csv' }

    it 'loads Array instance from csv file' do
      csv = CompactCSV.read(csv_path)
      expect(csv).to be_instance_of(Array)
    end

    it 'loads CompactCSV::Table instance from csv file' do
      csv = CompactCSV.read(csv_path, headers: true)
      expect(csv).to be_instance_of(CompactCSV::Table)
      expect(csv).to be_kind_of(CSV::Table)
    end
  end
end

describe CompactCSV::Table do
  describe '#each' do
    let(:csv) { CompactCSV.read('./spec/data/sample.csv', headers: true) }

    it 'returns rows iterator' do
      csv.each do |row|
        expect(row).to be_instance_of(CompactCSV::Row)
      end
    end
  end
end

describe CompactCSV::Row do
  let(:csv) { CompactCSV.read('./spec/data/sample.csv', headers: true) }
  let(:row) { csv.each.first }

  describe '#each' do
    it 'returns fields iterator' do
      row.each do |field|
        expect(field).to be_instance_of(Array)
      end
    end
  end

  describe '#field' do
    it 'reads field value' do
      expect(row['ID']).to eq '1'
      expect(row[0]).to eq '1'
      expect(row['VALUE']).to eq 'A'
      expect(row[1]).to eq 'A'
    end
  end

  describe '#fields' do
    it 'returns fileds of array' do
      expect(row.fields).to eq ['1', 'A']
    end

    it 'returns specific fields of array' do
      expect(row.fields('VALUE')).to eq ['A']
    end
  end

  describe '#size' do
    it 'returns size of fields' do
      expect(row.size).to be 2
    end
  end

  describe '#to_hash' do
    it 'returns hash form' do
      expect(row.to_hash).to eq({ 'ID' => '1', 'VALUE' => 'A' })
    end
  end

  describe '#[]=' do
    it 'change field value' do
      modify_row = row.dup
      modify_row['VALUE'] = 'AAA'
      expect(modify_row.fields).to eq ['1', 'AAA']
    end
  end
end
