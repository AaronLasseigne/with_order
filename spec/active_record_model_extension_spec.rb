require 'spec_helper'

describe 'WithOrder::ActiveRecordModelExtention' do
  describe '#with_order(order, options = {})' do
    context 'orders using a field' do
      it 'where the order is a hash containing :order' do
        npw = NobelPrizeWinner.with_order({order: 'first_name-asc'})
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should == nil
      end

      it 'where the order is a symbol' do
        npw = NobelPrizeWinner.with_order(:first_name)
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should == nil
      end

      it 'where the order is a string' do
        npw = NobelPrizeWinner.with_order('first_name-asc')
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should == nil
      end
    end

    context 'limit the need for specifying table names to resolve ambiguity' do
      it 'prepends the table name to the field if the field is in the primary table' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_order(:id)
        npw.order_values.should == ['"nobel_prize_winners.id" ASC']
      end
      
      it 'skips fields where a table is already provided' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_order('nobel_prizes.year')
        npw.order_values.should == ['"nobel_prizes.year" ASC']
      end

      it 'does not affect non-primary fields' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_order(:year)
        npw.order_values.should == ['"year" ASC']
      end
    end

    it 'reverses order using a field' do
      npw = NobelPrizeWinner.with_order({order: 'first_name-desc'})
      npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
      npw.reverse_order_value.should be true
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_order({order: 'first_name-asc'}).limit(1)
      npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
      npw.reverse_order_value.should == nil
    end

    context 'order is blank' do
      it 'skips the order' do
        npw = NobelPrizeWinner.with_order.limit(1)
        npw.order_values.should == []
      end
    end

    context 'order does not include a direction' do
      it 'defaults to "ASC"' do
        npw = NobelPrizeWinner.with_order({order: 'first_name'})
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
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
      it 'defaults to the field when no order is passed' do
        npw = NobelPrizeWinner.with_order({}, {default: 'first_name-desc'})
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should be true
      end

      it 'does not default to the field when a order is passed' do
        npw = NobelPrizeWinner.with_order({order: 'first_name'}, {default: 'last_name'})
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should == nil
      end
    end

    context 'the :param_namespace option is passed' do
      it 'finds the :order param from the hash using the namespace' do
        npw = NobelPrizeWinner.with_order({foo: {order: 'first_name'}}, {param_namespace: :foo})
        npw.order_values.should == ['"nobel_prize_winners.first_name" ASC']
        npw.reverse_order_value.should == nil
      end

      it 'skips order if it cannot find :order in the namespace' do
        npw = NobelPrizeWinner.with_order({bar: {order: 'first_name'}}, {param_namespace: :foo})
        npw.order_values.should == []
        npw.reverse_order_value.should == nil
      end
    end
  end

  describe 'WithOrder::ActiveRecordModelExtension Relation' do
    context '#current_order' do
      it 'returns the field being ordered on' do
        npw = NobelPrizeWinner.with_order({order: 'first_name-asc'})
        npw.current_order[:field].should == :first_name
        npw.current_order[:dir].should == :asc
        npw.current_order[:param_namespace].should == nil 
      end

      it 'returns nil for all keys if no field is ordered on' do
        npw = NobelPrizeWinner.with_order
        npw.current_order[:field].should == nil
        npw.current_order[:dir].should == nil 
        npw.current_order[:param_namespace].should == nil 
      end

      it 'returns the :param_namespace if passed' do
        npw = NobelPrizeWinner.with_order(:first_name, {param_namespace: :foo})
        npw.current_order[:field].should == :first_name
        npw.current_order[:dir].should == :asc
        npw.current_order[:param_namespace].should == :foo 
      end
    end

    context '#to_a' do
      it 'returns an array with #current_order attached' do
        npw = NobelPrizeWinner.with_order(:first_name, {param_namespace: :foo}).to_a
        npw.current_order[:field].should == :first_name
        npw.current_order[:dir].should == :asc
        npw.current_order[:param_namespace].should == :foo 
      end
    end
  end
end
