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

    def self.tabulate_by_user_week(users_count, order_weeks = 8)
      # this would be much simpler if I knew order_id was an always-increasing number for orders from a given user
      previously_ordered_ids = []
      new_row = []
      self.group_by_week(:created_at).count.each_with_index do |(week, count), weeknum|
        next if weeknum >= order_weeks
        order_timespan = week..(week + 1.week)
        sub_orders = self.where(created_at: order_timespan)
        if sub_orders.any?
          orderer_ids = sub_orders.pluck(:user_id).uniq
          new_orderer_ids = orderer_ids - previously_ordered_ids
          col_data = "#{to_percent(orderer_ids.count, users_count)} orderers (#{orderer_ids.count})\n#{to_percent(new_orderer_ids.count, users_count)} 1st Time (#{new_orderer_ids.count})"
          previously_ordered_ids = (previously_ordered_ids + orderer_ids).uniq
          col_data = '' if orderer_ids.empty?
          new_row << col_data
        else
          new_row << ''
        end
      end
      new_row
    end
  end
end
