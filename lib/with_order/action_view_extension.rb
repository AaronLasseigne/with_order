module WithOrder
  module ActionViewExtension
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
        (scope.current_order[:field] == field and (scope.current_order[:dir].blank? or scope.current_order[:dir].downcase == 'asc')) ?
        'desc' :
        'asc'
      )

      link_to(text, params.merge({order: "#{field}-#{dir}"}), html_options)
    end
  end
end
