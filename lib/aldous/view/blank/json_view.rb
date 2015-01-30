require 'aldous/respondable/renderable'

module Aldous
  module View
    module Blank
      class JsonView < Respondable::Renderable
        def template
          {
            json: {}
          }
        end
      end
    end
  end
end

