module WithOrder
  module ActionViewExtension
    def with_order_link(*args, &block)
      text = field = ''
      html_options = {}

      if block_given?
        text         = capture(&block)
        field        = args[0]
        html_options = args[1] || {}
      else
        text         = args[0]
        field        = args[1]
        html_options = args[2] || {}
      end

      dir = html_options.delete(:dir) || ((params[:sort] == field.to_s and (params[:dir].blank? or params[:dir].downcase == 'asc')) ? 'desc' : 'asc')

      link_to(text, params.merge({sort: field, dir: dir}), html_options)
    end
  end
end
