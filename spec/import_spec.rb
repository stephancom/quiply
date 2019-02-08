RSpec.describe Quiply::Import do
  describe 'time normalization' do  
    original_stderr = $stderr
    original_stdout = $stdout
    before(:all) do
      # Redirect stderr and stdout
      $stderr = File.open(File::NULL, "w")
      $stdout = File.open(File::NULL, "w")
    end
    after(:all) do
      $stderr = original_stderr
      $stdout = original_stdout
    end

    let(:wrong_format) { '02/23/1968 06:30:00' }
    let(:right_format) { '1968-02-23 06:30:00 -0800' }
    it 'should turn normalize a time string' do
      expect(described_class.normalize_time(wrong_format)).to eq(right_format)
    end

    describe 'stamps' do
      let(:bad_hash) { { created_at: wrong_format, updated_at: wrong_format, other_time: wrong_format } }
      let(:normalized) { described_class.normalize_stamps(bad_hash) }
      it 'should normalize created_at time' do
        expect(normalized[:created_at]).to eq(right_format)
      end
      it 'should normalize updated_at time' do
        expect(normalized[:updated_at]).to eq(right_format)
      end
      it 'should leave other_time untouched' do
        expect(normalized[:other_time]).to eq(wrong_format)
      end
      it 'should not crash if fields missing' do
        expect {
          described_class.normalize_stamps({})
        }.not_to raise_exception
      end
    end

    describe 'importing' do
      let(:fixtures_path) { 'spec/fixtures' }
      let(:csv_file) { "#{fixtures_path}/simple.csv" }
      let(:new_lines) { 9 }
      let(:new_record) { double('some record', valid?: true, save!: true) }
      let(:klass) { double('Some Class', new: new_record) }
      let(:mock_bar) { double('Some Progress Bar', increment: true, finish: true) }
      let(:two_bad) { ([false, false] + [true] * (new_lines - 2)).sample(new_lines) }
      before do
        allow(ProgressBar).to receive(:create).and_return(mock_bar)
      end

      it 'should open the desired file' do
        expect(File).to receive(:open).with(csv_file, 'r:utf-8').and_call_original
        described_class.new(klass).import(csv_file)
      end

      it 'should try to make one record per CSV line' do
        expect(klass).to receive(:new).exactly(new_lines).times
        described_class.new(klass).import(csv_file)
      end

      it 'should normalize every record timestamps' do
        expect(described_class).to receive(:normalize_stamps).exactly(new_lines).times
        described_class.new(klass).import(csv_file)
      end

      it 'should not save records that are not valid' do
        expect(new_record).to receive(:valid?).exactly(new_lines).times.and_return(*two_bad)
        expect(new_record).to receive(:save!).exactly(new_lines - 2).times
        described_class.new(klass).import(csv_file)
      end

      # The progress bar should probably not be in Quiply::Import directly, but meh.
      describe 'the progress bar' do
        it 'should start with correct data' do
          expect(ProgressBar).to receive(:create).with(total: new_lines, title: csv_file, format: '%t %c of %C |%B|').once.and_return(mock_bar)
          described_class.new(klass).import(csv_file)
        end

        it 'should increment once per record' do
          expect(mock_bar).to receive(:increment).exactly(new_lines).times.and_return(true)
          described_class.new(klass).import(csv_file)
        end

        it 'should increment even when records are bad' do
          expect(mock_bar).to receive(:increment).exactly(new_lines).times.and_return(true)
          expect(new_record).to receive(:valid?).exactly(new_lines).times.and_return(*two_bad)
          described_class.new(klass).import(csv_file)
        end

        it 'should close when done' do
          expect(mock_bar).to receive(:finish).once.and_return(true)
          described_class.new(klass).import(csv_file)
        end
      end
    end
  end
end
