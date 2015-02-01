module Aldous
  module Respondable
    class Base
      attr_reader :result, :view_context

      def initialize(result, view_context)
        @result = result
        @view_context = view_context
      end

      def build_result(data_hash)
        result.class.new(data_hash)
      end
    end
  end
end
