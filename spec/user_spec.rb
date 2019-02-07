require 'pry'
RSpec.describe Quiply::User do
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
      expect(user.orders).to have(1).items
    end

    it 'should include the specified' do
      expect(user.orders).to include(order)
    end
  end
end
