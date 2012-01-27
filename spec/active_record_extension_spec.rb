require 'spec_helper'

describe 'AddOrder::ActiveRecordExtention' do
  describe '#add_order' do
    context 'no :sort passed' do
      it 'skips the order' do
        npw = NobelPrizeWinner.add_order({}).limit(1)
        npw.order_values.should == []
      end
    end

    it 'adds order information to a query' do
      npw = NobelPrizeWinner.add_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name asc']

      npw = NobelPrizeWinner.limit(1).add_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name asc']

      npw = NobelPrizeWinner.add_order({sort: 'first_name', dir: 'asc'}).limit(1)
      npw.order_values.should == ['first_name asc']
    end
  end
end
