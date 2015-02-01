require 'aldous/respondable/renderable'

module Aldous
  module View
    module Blank
      class HtmlView < Respondable::Renderable
        def template
          {
            html: "", layout: true
          }
        end
      end
    end
  end
end

