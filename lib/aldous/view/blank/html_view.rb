require 'aldous/renderable'

module Aldous
  module View
    module Blank
      class HtmlView
        include Renderable

        def template
          {
            html: "<div></div>".html_safe, layout: true
          }
        end
      end
    end
  end
end

