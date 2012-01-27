require 'spec_helper'

describe 'AddOrder::ActiveRecordExtention' do
  describe '#add_order(params)' do
    it 'can be the only scope in the chain' do
      npw = NobelPrizeWinner.add_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name asc']
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.add_order({sort: 'first_name', dir: 'asc'}).limit(1)
      npw.order_values.should == ['first_name asc']
    end

    context 'params do not include :sort' do
      it 'skips the order' do
        npw = NobelPrizeWinner.add_order({}).limit(1)
        npw.order_values.should == []
      end
    end

    context 'params do not include :dir' do
      it 'defaults to "ASC"' do
        npw = NobelPrizeWinner.add_order({sort: 'first_name'})
        npw.order_values.should == ['first_name ASC']
      end
    end
  end
end
