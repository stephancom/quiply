require 'ruby-progressbar'
require 'smarter_csv'

module Quiply
  class Import
    def initialize(klass, mapping = { id: :old_id })
      @klass = klass
      @mapping = mapping
    end

    # time in CSV is in nonstandard format mm/dd/yyyy hh:mm:ss
    # also, we've been told they "occured in PDT" so might as well try to handle that with the '-0800'
    MMDDYY_HHMMSS_REGEXP = /(?<month>\d\d)\/(?<day>\d\d)\/(?<year>\d\d\d\d)\s(?<time>\d\d:\d\d:\d\d)/.freeze
    def self.normalize_time(str)
      parts = str.match(MMDDYY_HHMMSS_REGEXP)
      "#{parts[:year]}-#{parts[:month]}-#{parts[:day]} #{parts[:time]} -0800"
    end

    # could be more robust
    def self.normalize_stamps(attrs)
      attrs[:created_at] = normalize_time(attrs[:created_at]) if attrs.key?(:created_at)
      attrs[:updated_at] = normalize_time(attrs[:updated_at]) if attrs.key?(:updated_at)
      attrs
    end

    def import(filename)
      csv = SmarterCSV.process(filename, key_mapping: @mapping)
      progressbar = ProgressBar.create(total: csv.size, title: filename, format: '%t %c of %C |%B|')
      csv.each do |attrs|
        progressbar.increment
        attrs = Import.normalize_stamps(attrs)
        record = @klass.new(attrs)
        next unless record.valid? # skip invalid records

        record.save!
      end
      progressbar.finish
    end
  end
end
