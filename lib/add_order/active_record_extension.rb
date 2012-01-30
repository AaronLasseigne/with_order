module AddOrder
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      def self.add_order(params, options = {})
        return self if params[:sort].blank?

        order_text = "#{params[:sort]} ASC"
        if options[:fields] and options[:fields][params[:sort].to_sym]
          order_text = options[:fields][params[:sort].to_sym]
        end

        if params[:dir] and params[:dir].downcase == 'desc'
          order(order_text).reverse_order
        else
          order(order_text)
        end
      end
    end
  end
end
