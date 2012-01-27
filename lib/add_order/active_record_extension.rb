module AddOrder
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      def self.add_order(params)
        order("#{params[:sort]} #{params[:dir]}")
      end
    end
  end
end
