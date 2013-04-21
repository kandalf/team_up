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

    def show_flash_message
      markup = []

      if flash.has_key?(:info)
        markup << "<div class='alert alert-success'>#{flash[:info]}</div>"
        flash.delete(:info)
      end

      if flash.has_key?(:success)
        markup << "<div class='alert alert-success'>#{flash[:success]}</div>"
        flash.delete(:success)
      end

      if flash.has_key?(:warning)
        markup << "<div class='alert alert-success'>#{flash[:warning]}</div>"
        flash.delete(:warning)
      end

      if flash.has_key?(:error)
        markup << "<div class='alert alert-success'>#{flash[:error]}</div>"
        flash.delete(:error)
      end

      markup.join("<br/>")
    end
  end
end
