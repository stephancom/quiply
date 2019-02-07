module Quiply
  # Represents a User record
  #
  # @since v0.1.0
  class User < ActiveRecord::Base
    ActiveRecord::Schema.define do
      create_table :users, force: true do |t|
        t.integer :old_id, null: false
        t.timestamps
      end
    end

    has_many :orders, primary_key: :old_id, dependent: :destroy, inverse_of: :user
    validates :old_id, uniqueness: true
  end
end
