class Cuba
  module Render::Helper
    def link_to(path, text, html_attrs = {})
      link = "<a href='#{path}'"
      
      if html_attrs.is_a?(Hash)
        attrs = ' '
        html_attrs.each do |k, v|
          attrs << "#{k.to_s}='#{v.to_s}'"
        end
        link << attrs
      end
      
      link << ">#{text}</a>"
    end
  end
end
