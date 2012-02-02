require 'with_order/engine'
require 'with_order/active_record_extension'
require 'with_order/active_record_model_extension'
require 'with_order/action_view_extension'
require 'with_order/version'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, WithOrder::ActiveRecordExtension)
end
ActiveSupport.on_load(:action_view) do
  ActionView::Base.send(:include, WithOrder::ActionViewExtension)
end
