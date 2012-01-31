module AddOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    module RelationExtension
      def current_ordered_dir
        if current_ordered_field.nil?
          nil
        else
          self.reverse_order_value ? 'desc' : 'asc'
        end
      end
    end

    included do
      scope :add_order, ->(params, options = {}) {
        relation = scoped.extending(RelationExtension) do
          define_method :current_ordered_field do
            current_field = "#{(params[:sort] || options[:default])}"
            current_field = nil if current_field.blank?
            current_field.try(:to_sym)
          end
        end

        return relation if relation.current_ordered_field.blank?

        order_text = "#{relation.current_ordered_field} ASC"
        if options[:fields] and options[:fields][relation.current_ordered_field]
          order_text = options[:fields][relation.current_ordered_field]
        end

        if params[:dir] and params[:dir].downcase == 'desc'
          relation.order(order_text).reverse_order
        else
          relation.order(order_text)
        end
      }
    end
  end
end
