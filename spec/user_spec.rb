require 'pry'
RSpec.describe Quiply::User do
  describe 'creation' do  
    let(:old_user_id) { 123 }
    let!(:user) { User.create(old_id: old_user_id) }

    subject { user }

    it { is_expected.to be_valid, subject.errors.map { |k, v| "#{k} #{v}" }.join(', ') }
    it { is_expected.to respond_to(:old_id) }
    it { is_expected.to respond_to(:orders) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }

    describe 'without orders' do
      it 'should have no orders' do
        expect(user.orders.reload).to be_empty
      end
    end

    describe 'with one order' do
      let(:old_order_id) { 345 }
      let(:order_num) { 678 }
      let!(:order) { Order.create(old_id: old_order_id, user_id: user.old_id, order_num: order_num) }

      it 'should have one order' do
        expect(user.orders).to have(1).item
      end

      it 'should include the specified' do
        expect(user.orders).to include(order)
      end
    end
  end

  describe 'tabulate_new_by_join_week' do
    include_context 'four users with thirteen orders'

    it 'should return the expected number of rows' do
      expect(User.tabulate_new_by_join_week).to have(2).items
    end

    it 'should return the expected data' do
      expect(User.tabulate_new_by_join_week).to eq([['10/26-11/2', '1 users',
                                                     "100% orderers (1)\n100% 1st Time (1)\n",
                                                     "100% orderers (1)\n0% 1st Time (0)\n",
                                                     "100% orderers (1)\n0% 1st Time (0)\n"],
                                                    ['11/2-11/9', '3 users',
                                                     "33% orderers (1)\n33% 1st Time (1)\n",
                                                     "33% orderers (1)\n33% 1st Time (1)\n",
                                                     "66% orderers (2)\n33% 1st Time (1)\n",
                                                     "33% orderers (1)\n0% 1st Time (0)\n"]])
    end
  end
end
