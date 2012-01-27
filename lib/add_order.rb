require 'add_order/engine'
require 'add_order/active_record_extension'
require 'add_order/version'
require 'active_record'

ActiveRecord::Base.send(:include, AddOrder::ActiveRecordExtension)
