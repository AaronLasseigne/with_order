require 'spec_helper'

describe WithOrder::ActionViewExtension do
  describe '#link_with_order(*args, &block)' do
    context 'the current field ordered on is "first_name"' do
      it 'reverses the existing direction if the field is "first_name"' do
        helper.stub!(:params).and_return({order: 'first_name-asc'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.link_with_order(
          (npw.current_order[:field] == :first_name and npw.current_order[:dir] == :asc) ? 'DESC' : 'ASC',
          npw,
          :first_name
        ).should == '<a href="/assets?order=first_name-desc">DESC</a>'
      end

      it 'creates an "asc" order for fields other than "first_name"' do
        helper.stub!(:params).and_return({order: 'first_name-asc'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.link_with_order(
          (npw.current_order[:field] == :last_name and npw.current_order[:dir] == :asc) ? 'DESC' : 'ASC',
          npw,
          :last_name
        ).should == '<a href="/assets?order=last_name-asc">ASC</a>'
      end

      it 'defaults to "desc" if no direction is given' do
        helper.stub!(:params).and_return({order: 'first_name'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.link_with_order(
          (npw.current_order[:field] == :first_name and npw.current_order[:dir] == :asc) ? 'DESC' : 'ASC',
          npw,
          :first_name
        ).should == '<a href="/assets?order=first_name-desc">DESC</a>'
      end
    end

    context 'the :dir option is passed' do
      it 'uses the provided :dir option as the param value' do
        helper.stub!(:params).and_return({order: 'first_name-asc'})
        npw = NobelPrizeWinner.with_order(helper.params)
        helper.link_with_order(
          'ASC',
          npw,
          :first_name,
          {dir: :asc}
        ).should == '<a href="/assets?order=first_name-asc">ASC</a>'
      end
    end

    context '#current_order on the scope includes a :param_namespace' do
      it 'namespaces the :order param' do
        helper.stub!(:params).and_return({foo: {order: 'first_name-asc'}})
        npw = NobelPrizeWinner.with_order(helper.params, {param_namespace: :foo})
        helper.link_with_order(
          (npw.current_order[:field] == :first_name and npw.current_order[:dir] == :asc) ? 'DESC' : 'ASC',
          npw,
          :first_name
        ).should == '<a href="/assets?foo%5Border%5D=first_name-desc">DESC</a>'
      end
    end

    it 'accepts #link_to options' do
      helper.stub!(:params).and_return({order: 'first_name-asc'})
      npw = NobelPrizeWinner.with_order(helper.params)
      helper.link_with_order(
        'ASC',
        npw,
        :first_name,
        {dir: :asc, remote: true}
      ).should == '<a href="/assets?order=first_name-asc" data-remote="true">ASC</a>'
    end

    it 'accepts blocks' do
      helper.stub!(:params).and_return({order: 'first_name-asc'})
      npw = NobelPrizeWinner.with_order(helper.params)
      output = helper.link_with_order(npw, :first_name, {remote: true}) do
        (npw.current_order[:field] == :first_name and npw.current_order[:dir] == :asc) ? 'DESC' : 'ASC'
      end
      output.should == '<a href="/assets?order=first_name-desc" data-remote="true">DESC</a>'
    end
  end
end
