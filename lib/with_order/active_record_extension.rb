module WithOrder
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :inherited, :with_order
      end

      self.descendants.each do |descendant|
        descendant.send(:include, WithOrder::ActiveRecordModelExtension) if descendant.ancestors.include?(ActiveRecord::Base)
      end
    end

    module ClassMethods
      def inherited_with_with_order(base)
        inherited_without_with_order(base)
        base.send(:include, WithOrder::ActiveRecordModelExtension) if base.ancestors.include?(ActiveRecord::Base)
      end
    end
  end
end
