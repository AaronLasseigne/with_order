module WithOrder
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    module CurrentOrder
      # @return [Hash<:field, :dir, :param_namespace>] Properties relating to the current ordering.
      #
      # @since 0.1.0
      attr_accessor :current_order
    end

    # Attaches an order to the scope.
    #
    # @example
    #   Account.with_order(params, default: :full_name, fields: {full_name: 'first_name ASC, last_name ASC'})
    #
    # @scope class
    # @overload with_order(order, options={})
    #   @param [Hash, String, Symbol] order Defines the field to sort on. Hashes are expected to have
    #     an `:order` key. Strings can contain a direction by using a dash between the field name and
    #     the desired sorting direction (e.g. 'first_name-asc').
    #   @param [Hash] options
    #   @option options [String, Symbol] :default Defines a default field to sort on.
    #   @option options [Symbol] :param_namespace When `order` is a Hash this defines a namespace for the `:order` param.
    #   @option options [Hash<String>] :fields A mapping of field names to custom orderings.
    #
    #   @example Where order is a Hash. Usually the Hash would be `params`.
    #     Account.with_order({order: 'first_name-asc'})
    #
    #   @example Where order is a String.
    #     Account.with_order('first_name-asc')
    #
    #   @example Where order is a Symbol.
    #     Account.with_order(:first_name)
    #
    # @return [ActiveRecord::Relation]
    #
    # @since 0.1.0
    included do
      self.scope :with_order, ->(order = nil, options = {}) {
        relation = self.scoped.extending do
          extend WithOrder::HashExtraction

          if order.is_a?(Hash)
            order = self.extract_hash_value(order, options.has_key?(:param_namespace) ? "#{options[:param_namespace]}[:order]" : :order)
          end
          order = (order || options[:default]).to_s

          # See the accessor above in CurrentOrder for documentation.
          define_method :current_order do
            field = dir = nil
            field, dir = order.match(/^(.*?)(?:-(asc|desc))?$/i).captures if order
            dir ||= :asc

            if field.blank?
              {field: nil, dir: nil, param_namespace: options[:param_namespace].try(:to_sym)}
            else
              {
                field:           field.to_sym,
                dir:             (dir.to_sym || (self.reverse_order_value ? :desc : :asc)),
                param_namespace: options[:param_namespace].try(:to_sym)
              }
            end
          end

          # Attach current_order to the created Array so we don't lose the data.
          def to_a
            a = super.extend(CurrentOrder)
            a.current_order = self.current_order
            a
          end
        end

        # move on if we don't have a field to order on
        return relation unless relation.current_order[:field]

        # generate the order text
        order_text = ''
        if options[:fields] and options[:fields][relation.current_order[:field]]
          order_text = options[:fields][relation.current_order[:field]]
        else
          field = relation.current_order[:field].to_s

          if field !~ /\./
            quoted_field = relation.connection.quote_column_name(field)
            field = relation.column_names.include?(field) ? "#{self.table_name}.#{quoted_field}" : quoted_field
          end

          order_text = "#{field} ASC"
        end

        # add the order and reverse direction if necessary
        if relation.current_order[:dir].try(:downcase) == :desc
          relation.reorder(order_text).reverse_order
        else
          relation.reorder(order_text)
        end
      }
    end
  end
end
