require 'add_order/engine'
require 'add_order/active_record_extension'
require 'add_order/active_record_model_extension'
require 'add_order/version'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, AddOrder::ActiveRecordExtension)
end
