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


module Quiply
  class Error < StandardError; end
  # Your code goes here...
end
