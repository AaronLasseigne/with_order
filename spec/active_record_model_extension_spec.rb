require 'spec_helper'

describe 'WithOrder::ActiveRecordModelExtention' do
  describe '#with_order(order, options = {})' do
    context 'orders using a field' do
      it 'where the order is a hash containing :order' do
        npw = NobelPrizeWinner.with_order({order: 'first_name-asc'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'where the order is a symbol' do
        npw = NobelPrizeWinner.with_order(:first_name)
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'where the order is a string' do
        npw = NobelPrizeWinner.with_order('first_name-asc')
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end
    end

    it 'reverses order using a field' do
      npw = NobelPrizeWinner.with_order({order: 'first_name-desc'})
      npw.order_values.should == ['first_name ASC']
      npw.reverse_order_value.should be true
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_order({order: 'first_name-asc'}).limit(1)
      npw.order_values.should == ['first_name ASC']
      npw.reverse_order_value.should == nil
    end

    context 'params do not include :order' do
      it 'skips the order' do
        npw = NobelPrizeWinner.with_order({}).limit(1)
        npw.order_values.should == []
      end
    end

    context 'params do not include a direction' do
      it 'defaults to "ASC"' do
        npw = NobelPrizeWinner.with_order({order: 'first_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end
    end

    context 'options include :fields to define custom ORDER BY statements' do
      it 'orders using custom fields' do
        npw = NobelPrizeWinner.with_order({order: 'full_name'}, {
          fields: {
            full_name: 'first_name ASC, last_name ASC'
          }
        })
        npw.order_values.should == ['first_name ASC, last_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'reverses order using custom fields' do
        npw = NobelPrizeWinner.with_order({order: 'full_name-desc'}, {
          fields: {
            full_name: 'first_name ASC, last_name ASC'
          }
        })
        npw.order_values.should == ['first_name ASC, last_name ASC']
        npw.reverse_order_value.should be true
      end
    end

    context 'options include :default to select a default field to order by' do
      it 'should default to the field when no :order param is passed' do
        npw = NobelPrizeWinner.with_order({}, {default: 'first_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'should not default to the field when a :order param is passed' do
        npw = NobelPrizeWinner.with_order({order: 'first_name'}, {default: 'last_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end
    end
  end

  describe 'WithOrder::ActiveRecordModelExtension Relation' do
    context '#current_order' do
      it 'returns the field being ordered on' do
        npw = NobelPrizeWinner.with_order({order: 'first_name-asc'})
        # fix the symbol/string inconsistency later
        npw.current_order[:field].should == :first_name
        npw.current_order[:dir].should == 'asc'
      end

      it 'returns nil for both :field and :dir if no field is ordered on' do
        npw = NobelPrizeWinner.with_order({})
        npw.current_order[:field].should == nil
        npw.current_order[:dir].should == nil 
      end
    end
  end
end
