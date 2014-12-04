require 'aldous/renderable'

module Aldous
  module View
    module Blank
      class AtomView
        include Renderable

        attr_reader :result, :view_context

        def initialize(result, view_context)
          @result = result
          @view_context = view_context
        end

        def template
        end
      end
    end
  end
end
