require 'spec_helper'

describe 'AddOrder::ActiveRecordExtention' do
  describe '#add_order' do
    it 'adds order information to a query' do
      npw = NobelPrizeWinner.add_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name asc']

      npw = NobelPrizeWinner.limit(1).add_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name asc']
    end
  end
end
