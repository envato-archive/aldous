module Aldous
  module View
    class BlankAtomView
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
