module WithOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      scope :with_order, ->(params, options = {}) {
        relation = scoped.extending do
          define_method :current_order do
            current_field = "#{(params[:order] || options[:default])}"
            if current_field.blank?
              {field: nil, dir: nil}
            else
              {field: current_field.to_sym, dir: self.reverse_order_value ? 'desc' : 'asc'}
            end
          end
        end

        return relation unless relation.current_order[:field]

        order_text = "#{relation.current_order[:field]} ASC"
        if options[:fields] and options[:fields][relation.current_order[:field]]
          order_text = options[:fields][relation.current_order[:field]]
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
