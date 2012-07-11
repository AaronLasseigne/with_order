module WithOrder
  module ActionViewExtension
    include WithOrder::HashExtraction

    def link_with_order(*args, &block)
      text = block_given? ? capture(&block) : args.shift
      scope, field, html_options = *args
      html_options ||= {}

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
