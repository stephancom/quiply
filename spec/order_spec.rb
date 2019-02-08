require 'shared_order_setup'

RSpec.describe Quiply::Order do
  describe 'building' do
    let(:old_user_id) { 123 }
    let!(:user) { User.create(old_id: old_user_id) }
    let(:old_order_id) { 345 }
    let(:order_num) { 678 }
    let!(:order) { Order.create(old_id: old_order_id, user_id: user.old_id, order_num: order_num) }

    subject { order }

    it { is_expected.to be_valid, subject.errors.map { |k, v| "#{k} #{v}" }.join(', ') }
    it { is_expected.to respond_to(:old_id) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:order_num) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }

    it 'should belong to the expected user' do
      expect(order.user).to eq(user)
    end
  end

  describe 'tabulation' do
    include_context 'four users with thirteen orders'

    it 'count_orders_by_week returns right number of weeks' do
      expect(Order.count_orders_by_week).to have(4).items
    end

    it 'count_orders_by_week should return the right data' do
      expect(Order.count_orders_by_week).to eq([{ orderers: 2, first_orders: 2 },
                                                { orderers: 2, first_orders: 1 },
                                                { orderers: 3, first_orders: 1 },
                                                { orderers: 1, first_orders: 0 }])
    end

    it 'count_orders_by_week limits weeks' do
      expect(Order.count_orders_by_week(2)).to have(2).items
    end

    it 'tabulate_by_user_week should return the right number of weeks' do
      expect(Order.tabulate_by_user_week(4)).to have(4).items
    end

    it 'tabulate_by_user_week should return the right data' do
      expect(Order.tabulate_by_user_week(4)).to eq(["50% orderers (2)\n50% 1st Time (2)\n",
                                                    "50% orderers (2)\n25% 1st Time (1)\n",
                                                    "75% orderers (3)\n25% 1st Time (1)\n",
                                                    "25% orderers (1)\n0% 1st Time (0)\n"])
    end

    it 'tabulate_by_user_week limits weeks' do
      expect(Order.tabulate_by_user_week(4, 2)).to have(2).items
    end

    it 'tabulate_by_user_week should limit to the right data' do
      expect(Order.tabulate_by_user_week(4, 2)).to eq(["50% orderers (2)\n50% 1st Time (2)\n",
                                                       "50% orderers (2)\n25% 1st Time (1)\n"])
    end
  end
end
