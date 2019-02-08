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

    def self.to_percent(count, total, digits = 0)
      "#{((count * 100) / total).round(digits)}%"
    end

    SPAN_FORMAT = '%-m/%-d'.freeze
    def self.timespan_format(span)
      [span.first, span.last].map { |t| t.strftime(SPAN_FORMAT) }.join('-')
    end

    def self.tabulate_new_by_join_week(order_weeks = 8)
      rows = []
      by_week = self.group_by_week(:created_at).count
      by_week.each do |week, count|
        new_row = []
        timespan = week..(week + 1.week)
        new_row << timespan_format(timespan)
        users = self.where(created_at: timespan)
        new_row << "#{count} users" # pluralize?
        # find all orders made by these users, ever
        user_orders = Order.where(user_id: users.pluck(:old_id))

        # this would be much simpler if I knew order_id was an always-increasing number for orders from a given user
        previously_ordered_ids = []
        user_orders.group_by_week(:created_at).count.each_with_index do |(week, count), weeknum|
          next if weeknum >= order_weeks
          order_timespan = week..(week + 1.week)
          sub_orders = user_orders.where(created_at: order_timespan)
          orderer_ids = sub_orders.pluck(:user_id).uniq
          new_orderer_ids = orderer_ids - previously_ordered_ids
          # puts weeknum.to_s * 40
          # puts "count should be #{count} is #{sub_orders.count}"
          # puts timespan_format(order_timespan)
          # puts orderer_ids.sort.inspect
          # puts previously_ordered_ids.sort.inspect
          # puts new_orderer_ids.sort.inspect
          # puts weeknum.to_s * 40
          col_data = "#{to_percent(orderer_ids.count, users.count)} orderers (#{orderer_ids.count})\n#{to_percent(new_orderer_ids.count, users.count)} 1st Time (#{new_orderer_ids.count})"
          previously_ordered_ids = (previously_ordered_ids + orderer_ids).uniq
          new_row << col_data
        end

        rows << new_row
      end
      rows
    end
  end
end
