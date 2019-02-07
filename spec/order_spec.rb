require 'pry'
RSpec.describe Quiply::Order do
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
