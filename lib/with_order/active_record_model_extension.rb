module WithOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern
    
    module CurrentOrder
      attr_accessor :current_order
    end

    included do
      self.scope :with_order, ->(order = nil, options = {}) {
        relation = self.scoped.extending do
          if order.is_a?(Hash)
            order = options[:param_namespace] ?
              order[options[:param_namespace].to_sym].try(:[], :order) :
              order[:order]
          end
          order = (order || options[:default]).to_s

          define_method :current_order do
            field = dir = nil
            field, dir = order.match(/^(.*?)(?:-(asc|desc))?$/i).captures if order
            dir ||= :asc

            if field.blank?
              {field: nil, dir: nil, param_namespace: nil}
            else
              {
                field:           field.to_sym,
                dir:             (dir.to_sym || (self.reverse_order_value ? :desc : :asc)),
                param_namespace: options[:param_namespace].try(:to_sym)
              }
            end
          end
        end

        return relation unless relation.current_order[:field]

        order_text = ''
        if options[:fields] and options[:fields][relation.current_order[:field]]
          order_text = options[:fields][relation.current_order[:field]]
        else
          field = relation.current_order[:field].to_s

          if field !~ /\./ and relation.column_names.include?(field)
            field = "#{self.table_name}.#{field}"
          end

          order_text = "#{relation.connection.quote_column_name(field)} ASC"
        end

        if relation.current_order[:dir].try(:downcase) == :desc
          relation.order(order_text).reverse_order
        else
          relation.order(order_text)
        end
      } do
        def to_a
          a = super.extend(CurrentOrder)
          a.current_order = self.current_order
          a
        end
      end
    end
  end
end
