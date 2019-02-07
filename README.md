# Quiply [![Build Status](https://travis-ci.org/stephancom/quiply.svg?branch=master)](https://travis-ci.org/stephancom/quiply)

Quip cohort challenge

# Spec
## What we need

Group users into week long cohorts based on the user's signup date. For each cohort, calculate:

- The number of *distinct users* (orderers) who ordered in the first 7 days *after signup*. Older cohorts will have more buckets: i.e. 0-7 days, 7-14 days, 14-21 days, etc...
- The number of *distinct users* who ordered for the first time in each bucket


## Output

Please output an html table or CSV that looks something like this. It should include Cohorts, # users, & entries for each bucket.

*(this is only an example. this is NOT real data)*

|  Cohort     |  Users    |  0-7 days  |  7-14 days  | 14-21 days | ....
|-------------|------------|-------------|------------|-------------|-------------
| 7/1-7/7     | 300 users   | 25% orderers (75)<br>25% 1st time (75) |             |            |
| 6/24-6/30   | 200 users   | 15% orderers (30)<br>15% 1st time (30) | 5% orderers (10)<br>1.5% 1st time (3) |            | 
| 6/17-6/23   | 100 users   | 30% orderers (30)<br>30% 1st time (30) | 10% orderers (10)<br>3% 1st time (3) |  15% orderers (15)<br>5% 1st time (5) | 
| ... | ... | ... | ... | ... | ...


## Data You Have

### User
* id
* created_at

### Orders
* id
* user_id
* created_at
* order_num **note: this field is 1-indexed**

## Notes

* Data ends in July '13
* You should default to 8 weeks back worth of cohorts, would be nice if this is customizable (via parameter or form or something)
* All dates are stored in UTC, but occured in PDT. Bonus points for handling that correctly.

## Usage

* install gem
* `quiply csv/users.csv csv/users.csv`

`quiply -h` is available, and explains additional configurable options, such as changing the time range or the output format.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stephancom/quiply. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Quiply project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/stephancom/quiply/blob/master/CODE_OF_CONDUCT.md).
