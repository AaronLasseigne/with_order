require 'spec_helper'

describe WithOrder::ActionViewExtension do
  describe '#with_order_link(*args, &block)' do
    context 'the current field ordered on is "first_name"' do
      it 'reverses the existing :dir if the field is "first_name"' do
        helper.stub!(:params).and_return({order: 'first_name', dir: 'asc'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.with_order_link(
          (npw.current_order[:field] == :first_name and npw.current_order[:dir] == 'asc') ? 'DESC' : 'ASC',
          :first_name
        ).should == '<a href="/assets?dir=desc&amp;order=first_name">DESC</a>'
      end

      it 'creates an "asc" order for fields other than "first_name"' do
        helper.stub!(:params).and_return({order: 'first_name', dir: 'asc'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.with_order_link(
          (npw.current_order[:field] == :last_name and npw.current_order[:dir] == 'asc') ? 'DESC' : 'ASC',
          :last_name
        ).should == '<a href="/assets?dir=asc&amp;order=last_name">ASC</a>'
      end

      it 'defaults to "desc" if no :dir param is given' do
        helper.stub!(:params).and_return({order: 'first_name'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.with_order_link(
          (npw.current_order[:field] == :first_name and npw.current_order[:dir] == 'asc') ? 'DESC' : 'ASC',
          :first_name
        ).should == '<a href="/assets?dir=desc&amp;order=first_name">DESC</a>'
      end
    end

    context 'the :dir option is passed' do
      it 'uses the provided :dir option as the param value' do
        helper.stub!(:params).and_return({order: 'first_name', dir: 'asc'})
        helper.with_order_link(
          'ASC',
          :first_name,
          {dir: 'asc'}
        ).should == '<a href="/assets?dir=asc&amp;order=first_name">ASC</a>'
      end
    end

    it 'accepts #link_to options' do
      helper.stub!(:params).and_return({order: 'first_name', dir: 'asc'})
      helper.with_order_link(
        'ASC',
        :first_name,
        {dir: 'asc', remote: true}
      ).should == '<a href="/assets?dir=asc&amp;order=first_name" data-remote="true">ASC</a>'
    end

    it 'accepts blocks' do
      helper.stub!(:params).and_return({order: 'first_name', dir: 'asc'})
      npw = NobelPrizeWinner.with_order(helper.params)
      output = helper.with_order_link(:first_name, {remote: true}) do
        (npw.current_order[:field] == :first_name and npw.current_order[:dir] == 'asc') ? 'DESC' : 'ASC'
      end
      output.should == '<a href="/assets?dir=desc&amp;order=first_name" data-remote="true">DESC</a>'
    end
  end
end
