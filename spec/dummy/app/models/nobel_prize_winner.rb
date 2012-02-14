class NobelPrizeWinner < ActiveRecord::Base
  has_many :nobel_prizes

  default_scope order('id ASC')
end
