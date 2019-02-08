RSpec.shared_context 'four users with thirteen orders' do
  let(:start_date) { Time.parse('2014-10-31 17:01:00 -0800') }
  let!(:first_user) { User.create(old_id: 1, created_at: start_date) }
  let!(:second_user) { User.create(old_id: 2, created_at: start_date + 1.day) }
  let!(:third_user) { User.create(old_id: 3, created_at: start_date + 3.days) }
  let!(:fourth_user) { User.create(old_id: 4, created_at: start_date + 5.days) }
  before(:each) do
    first_user.orders.create!(old_id: 101, created_at: start_date + 3.days, order_num: 1)
    first_user.orders.create!(old_id: 102, created_at: start_date + 4.days, order_num: 2)
    first_user.orders.create!(old_id: 103, created_at: start_date + 10.days, order_num: 3)
    first_user.orders.create!(old_id: 104, created_at: start_date + 20.days, order_num: 4)

    second_user.orders.create!(old_id: 105, created_at: start_date + 2.days, order_num: 1)
    second_user.orders.create!(old_id: 106, created_at: start_date + 20.days, order_num: 2)

    third_user.orders.create!(old_id: 107, created_at: start_date + 8.days, order_num: 1)
    third_user.orders.create!(old_id: 108, created_at: start_date + 10.days, order_num: 2)
    third_user.orders.create!(old_id: 109, created_at: start_date + 12.days, order_num: 2)
    third_user.orders.create!(old_id: 110, created_at: start_date + 13.days, order_num: 2)
    third_user.orders.create!(old_id: 111, created_at: start_date + 24.days, order_num: 2)

    fourth_user.orders.create!(old_id: 112, created_at: start_date + 15.days, order_num: 1)
    fourth_user.orders.create!(old_id: 113, created_at: start_date + 18.days, order_num: 2)
  end
end
