require 'aldous/renderable'

module Aldous
  module View
    module Blank
      class HtmlView
        include Renderable

        attr_reader :result, :view_context

        def initialize(result, view_context)
          @result = result
          @view_context = view_context
        end

        def template
          {
            html: "<div></div>".html_safe, layout: true
          }
        end
      end
    end
  end
end

