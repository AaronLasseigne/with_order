module AddOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      scope :add_order, ->(params, options = {}) {
        sort_field = params[:sort] || options[:default]

        return scoped if sort_field.blank?

        order_text = "#{sort_field} ASC"
        if options[:fields] and options[:fields][sort_field.to_sym]
          order_text = options[:fields][sort_field.to_sym]
        end

        if params[:dir] and params[:dir].downcase == 'desc'
          order(order_text).reverse_order
        else
          order(order_text)
        end
      }
    end
  end
end
