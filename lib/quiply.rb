require 'sqlite3'
require 'active_record'
require 'terminal-table'
require 'quiply/version'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

module Quiply
  class Error < StandardError; end
  # Your code goes here...
end
