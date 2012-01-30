module AddOrder
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :inherited, :add_order
      end

      self.descendants.each do |descendant|
        descendant.send(:include, AddOrder::ActiveRecordModelExtension) if descendant.ancestors.include?(ActiveRecord::Base)
      end
    end

    module ClassMethods
      def inherited_with_add_order(base)
        inherited_without_add_order(base)
        base.send(:include, AddOrder::ActiveRecordModelExtension) if base.ancestors.include?(ActiveRecord::Base)
      end
    end
  end
end
