require 'sqlite3'
require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

require 'terminal-table'
require 'quiply/version'
require 'quiply/user'
require 'quiply/order'
require 'quiply/import'

module Quiply
  class Error < StandardError; end

  # utilities
  SPAN_FORMAT = '%-m/%-d'.freeze
  def self.timespan_format(span)
    [span.first, span.last].map { |t| t.strftime(SPAN_FORMAT) }.join('-')
  end

  def self.to_percent(count, total, digits = 0)
    "#{((count * 100) / total).round(digits)}%"
  end
end
