module AddOrder
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      def self.add_order(params)
        if params[:sort].present?
          order("#{params[:sort]} #{params[:dir] || 'ASC'}")
        else
          self
        end
      end
    end
  end
end
