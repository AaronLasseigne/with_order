require 'spec_helper'

describe 'WithOrder::ActiveRecordModelExtention' do
  describe '#with_order(params, options = {})' do
    it 'orders using a field' do
      npw = NobelPrizeWinner.with_order({sort: 'first_name', dir: 'asc'})
      npw.order_values.should == ['first_name ASC']
      npw.reverse_order_value.should == nil
    end

    it 'reverses order using a field' do
      npw = NobelPrizeWinner.with_order({sort: 'first_name', dir: 'desc'})
      npw.order_values.should == ['first_name ASC']
      npw.reverse_order_value.should be true
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_order({sort: 'first_name', dir: 'asc'}).limit(1)
      npw.order_values.should == ['first_name ASC']
      npw.reverse_order_value.should == nil
    end

    context 'params do not include :sort' do
      it 'skips the order' do
        npw = NobelPrizeWinner.with_order({}).limit(1)
        npw.order_values.should == []
      end
    end

    context 'params do not include :dir' do
      it 'defaults to "ASC"' do
        npw = NobelPrizeWinner.with_order({sort: 'first_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end
    end

    context 'options include :fields to define custom ORDER BY statements' do
      it 'orders using custom fields' do
        npw = NobelPrizeWinner.with_order({sort: 'full_name'}, {
          fields: {
            full_name: 'first_name ASC, last_name ASC'
          }
        })
        npw.order_values.should == ['first_name ASC, last_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'reverses order using custom fields' do
        npw = NobelPrizeWinner.with_order({sort: 'full_name', dir: 'desc'}, {
          fields: {
            full_name: 'first_name ASC, last_name ASC'
          }
        })
        npw.order_values.should == ['first_name ASC, last_name ASC']
        npw.reverse_order_value.should be true
      end
    end

    context 'options include :default to select a default field to order by' do
      it 'should default to the field when no :sort param is passed' do
        npw = NobelPrizeWinner.with_order({}, {default: 'first_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end

      it 'should not default to the field when a :sort param is passed' do
        npw = NobelPrizeWinner.with_order({sort: 'first_name'}, {default: 'last_name'})
        npw.order_values.should == ['first_name ASC']
        npw.reverse_order_value.should == nil
      end
    end
  end

  describe 'WithOrder::ActiveRecordModelExtension::RelationExtension' do
    context '#current_ordered_field' do
      it 'returns the field being ordered on' do
        npw = NobelPrizeWinner.with_order({sort: 'first_name', dir: 'asc'})
        npw.current_ordered_field.should == :first_name
      end
    end

    context '#current_ordered_dir' do
      it 'returns the direction of the order' do
        npw = NobelPrizeWinner.with_order({sort: 'first_name', dir: 'asc'})
        npw.current_ordered_dir.should == 'asc'
      end
    end
  end
end
