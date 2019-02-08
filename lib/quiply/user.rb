module Quiply
  # Represents a User record
  #
  # @since v0.1.0
  class User < ActiveRecord::Base
    ActiveRecord::Schema.define do
      create_table :users, force: true do |t|
        t.integer :old_id, null: false, index: true
        t.timestamps
      end
    end

    has_many :orders, primary_key: :old_id, dependent: :destroy, inverse_of: :user
    validates :old_id, uniqueness: true

    SPAN_FORMAT = '%-m/%-d'.freeze
    def self.timespan_format(span)
      [span.first, span.last].map { |t| t.strftime(SPAN_FORMAT) }.join('-')
    end

    def self.tabulate_new_by_join_week(order_weeks = 8)
      group_by_week(:created_at).count.map do |(week, count)|
        timespan = week..(week + 1.week)
        users = where(created_at: timespan)
        user_orders = Order.where(user_id: users.pluck(:old_id))
        [timespan_format(timespan), "#{count} users"] + # TODO: I18n
          user_orders.tabulate_by_user_week(users.count, order_weeks)
      end
    end
  end
end
