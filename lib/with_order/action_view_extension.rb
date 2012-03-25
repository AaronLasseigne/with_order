module WithOrder
  module ActionViewExtension
    include WithOrder::HashExtraction

    # Create a link tag that changes how the data is ordered.
    #
    # @overload link_with_order(text, scope, field, options = {})
    #   @param [String] text The text to display.
    #   @param [ActiveRecord::Relation, Array] scope The data being ordered on.
    #   @param [Symbol] field The field represented by this sortable link.
    #   @param [Hash] options Options for the link.
    #   @option options [String] :dir Permanently fix the direction of the order.
    #
    #   @example
    #     <%= link_with_order('First Name', @data, :first_name) %> # => <a href="controller/action?order=first_name-desc">First Name</a>
    #
    # @overload link_with_order(scope, field, options = {}, &block)
    #   @param [ActiveRecord::Relation, Array] scope The data being ordered on.
    #   @param [Symbol] field The field represented by this sortable link.
    #   @param [Hash] options Options for the link.
    #   @option options [String] :dir Permanently fix the direction of the order.
    #   @param [Block] block The output for display.
    #
    #   @example
    #     <%= link_with_order(@data, :first_name) do %>
    #       <strong>First Name</strong>
    #     <% end %>
    #     # => <a href="controller/action?order=first_name-desc"><strong>First Name</strong></a>
    #
    # @return [String] An HTML anchor tag with the field sorting information.
    #
    # @since 0.1.0
    def link_with_order(*args, &block)
      text = scope = field = html_options = nil

      if block_given?
        text         = capture(&block)
        scope        = args[0]
        field        = args[1]
        html_options = args[2] || {}
      else
        text         = args[0]
        scope        = args[1]
        field        = args[2]
        html_options = args[3] || {}
      end

      dir = html_options.delete(:dir) || (
        (scope.current_order[:field] == field and (scope.current_order[:dir].blank? or scope.current_order[:dir].downcase == :asc)) ?
        'desc' :
        'asc'
      )

      param_namespace = scope.current_order[:param_namespace]
      scoped_params = (param_namespace ? self.extract_hash_value(params, param_namespace) : params).try(:dup) || {}
      scoped_params.merge!({order: "#{field}-#{dir}"})

      link_to(text, param_namespace ? params.merge({param_namespace => scoped_params}) : scoped_params, html_options)
    end
  end
end
