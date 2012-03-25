module WithOrder
  # @private
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :inherited, :with_order
      end

      # Attach the ActiveRecord extensions to children of ActiveRecord that were initiated before we loaded WithOrder.
      self.descendants.each do |descendant|
        descendant.send(:include, WithOrder::ActiveRecordModelExtension) if descendant.superclass == ActiveRecord::Base
      end
    end

    # @private
    module ClassMethods
      # Attaches the ActiveRecord extensions to children of ActiveRecord so we don't pollute ActiveRecord::Base.
      def inherited_with_with_order(base)
        inherited_without_with_order(base)
        base.send(:include, WithOrder::ActiveRecordModelExtension) if base.superclass == ActiveRecord::Base
      end
    end
  end
end
