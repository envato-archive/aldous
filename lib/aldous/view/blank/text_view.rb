require 'aldous/respondable/renderable'

module Aldous
  module View
    module Blank
      class TextView < Respondable::Renderable
        def template
          {
            text: "",
          }
        end
      end
    end
  end
end

