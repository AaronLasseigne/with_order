module WithOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      scope :with_order, ->(order, options = {}) {
        relation = scoped.extending do
          if order.is_a?(Hash)
            order = order[:order]
          end
          order = order.to_s if order

          define_method :current_order do
            field = dir = nil
            field, dir = order.match(/^(.*?)(?:-(asc|desc))?$/i).captures if order
            dir ||= 'asc'

            current_field = "#{(field || options[:default])}"
            if current_field.blank?
              {field: nil, dir: nil}
            else
              {field: current_field.to_sym, dir: (dir || (self.reverse_order_value ? 'desc' : 'asc'))}
            end
          end
        end

        return relation unless relation.current_order[:field]

        order_text = ''
        if options[:fields] and options[:fields][relation.current_order[:field]]
          order_text = options[:fields][relation.current_order[:field]]
        else
          order_text = "#{relation.connection.quote_column_name(relation.current_order[:field])} ASC"
        end

        if relation.current_order[:dir].try(:downcase) == 'desc'
          relation.order(order_text).reverse_order
        else
          relation.order(order_text)
        end
      }
    end
  end
end
