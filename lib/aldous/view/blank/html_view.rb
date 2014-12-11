require 'aldous/renderable'

module Aldous
  module View
    module Blank
      class HtmlView
        include Renderable

        def template
          {
            html: "", layout: true
          }
        end
      end
    end
  end
end

