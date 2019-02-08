module Quiply
  # Represents a User Order
  #
  # @since v0.1.0
  class Order < ActiveRecord::Base
    ActiveRecord::Schema.define do
      create_table :orders, force: true do |t|
        t.integer :old_id, null: false
        t.integer :order_num, null: false
        t.integer :user_id, null: false, index: true
        t.timestamps
      end
    end

    belongs_to :user, primary_key: :old_id, inverse_of: :orders, required: true
    validates :order_num, presence: true # doesn't seem to be unique?
    validates :old_id, uniqueness: true

    def self.to_percent(count, total, digits = 0)
      "#{((count * 100) / total).round(digits)}%"
    end

    def self.count_orders_by_week(weeks_count)
      group_by_week(:created_at).count.first(weeks_count).map do |(week, _)|
        week_orders = where(created_at: week..(week + 1.week))
        first_orders = week_orders.where(order_num: 1)
        { orderers: week_orders.pluck(:user_id).uniq.count,
          first_orders: first_orders.count }
      end
    end

    def self.tabulate_by_user_week(users_count, weeks_count = 8)
      count_orders_by_week(weeks_count).map do |w|
        # TODO: I18n
        <<~EOWEEK
          #{to_percent(w[:orderers], users_count)} orderers (#{w[:orderers]})
          #{to_percent(w[:first_orders], users_count)} 1st Time (#{w[:first_orders]})
        EOWEEK
      end
    end
  end
end
