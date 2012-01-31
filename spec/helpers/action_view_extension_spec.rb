require 'spec_helper'

describe AddOrder::ActionViewExtension do
  describe '#add_order_link(*args, &block)' do
    context 'the current field sorted on is "first_name"' do
      it 'reverses the existing :dir if the field is "first_name"' do
        helper.stub!(:params).and_return({sort: 'first_name', dir: 'asc'})
        helper.add_order_link(
          (helper.params[:sort] == 'first_name' and helper.params[:dir].try(:downcase) == 'asc') ? 'DESC' : 'ASC',
          :first_name
        ).should == '<a href="/assets?dir=desc&amp;sort=first_name">DESC</a>'
      end

      it 'creates an "asc" sort for fields other than "first_name"' do
        helper.stub!(:params).and_return({sort: 'first_name', dir: 'asc'})
        helper.add_order_link(
          (helper.params[:sort] == 'last_name' and helper.params[:dir].try(:downcase) == 'asc') ? 'DESC' : 'ASC',
          :last_name
        ).should == '<a href="/assets?dir=asc&amp;sort=last_name">ASC</a>'
      end

      it 'defaults to "asc" if no :dir param is given' do
        helper.stub!(:params).and_return({sort: 'first_name'})
        helper.add_order_link(
          (helper.params[:sort] == 'first_name' and helper.params[:dir].try(:downcase) == 'asc') ? 'DESC' : 'ASC',
          :first_name
        ).should == '<a href="/assets?dir=asc&amp;sort=first_name">ASC</a>'
      end
    end

    context 'the :dir option is passed' do
      it 'uses the provided :dir option as the param value' do
        helper.stub!(:params).and_return({sort: 'first_name', dir: 'asc'})
        helper.add_order_link(
          'ASC',
          :first_name,
          {dir: 'asc'}
        ).should == '<a href="/assets?dir=asc&amp;sort=first_name">ASC</a>'
      end
    end

    it 'accepts #link_to options' do
      helper.stub!(:params).and_return({sort: 'first_name', dir: 'asc'})
      helper.add_order_link(
        'ASC',
        :first_name,
        {dir: 'asc', remote: true}
      ).should == '<a href="/assets?dir=asc&amp;sort=first_name" data-remote="true">ASC</a>'
    end

    it 'accepts blocks' do
      helper.stub!(:params).and_return({sort: 'first_name', dir: 'asc'})
      output = helper.add_order_link(:first_name, {remote: true}) do
        (helper.params[:sort] == 'first_name' and helper.params[:dir].try(:downcase) == 'asc') ? 'DESC' : 'ASC'
      end
      output.should == '<a href="/assets?dir=desc&amp;sort=first_name" data-remote="true">DESC</a>'
    end
  end
end
