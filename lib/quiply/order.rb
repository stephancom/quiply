module Quiply
  # Represents a User Order
  #
  # @since v0.1.0
  class Order < ActiveRecord::Base
    ActiveRecord::Schema.define do
      create_table :orders, force: true do |t|
        t.integer :old_id, null: false
        t.integer :order_num, null: false
        t.integer :user_id, null: false
        t.timestamps
      end
    end

    belongs_to :user, primary_key: :old_id, inverse_of: :orders, required: true
    validates :order_num, uniqueness: true
    validates :old_id, uniqueness: true
  end
end
