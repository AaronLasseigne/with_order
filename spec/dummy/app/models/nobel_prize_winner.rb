class NobelPrizeWinner < ActiveRecord::Base
  has_many :nobel_prizes

  default_scope order('meaningless_time ASC')
end
