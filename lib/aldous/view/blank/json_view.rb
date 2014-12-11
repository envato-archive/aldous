require 'aldous/renderable'

module Aldous
  module View
    module Blank
      class JsonView
        include Renderable

        def template
          {
            json: {}
          }
        end
      end
    end
  end
end

