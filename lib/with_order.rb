require 'with_order/engine'
require 'with_order/hash_extraction'
require 'with_order/active_record_extension'
require 'with_order/active_record_model_extension'
require 'with_order/action_view_extension'
require 'with_order/version'

ActiveSupport.on_load(:active_record) do
  include WithOrder::ActiveRecordExtension
end
ActiveSupport.on_load(:action_view) do
  include WithOrder::ActionViewExtension
end
