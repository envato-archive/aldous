module Aldous
  module Dispatch
    class DetermineResponseType
      attr_reader :result, :result_to_response_type_mapping

      def initialize(result, result_to_response_type_mapping)
        @result = result
        @result_to_response_type_mapping = result_to_response_type_mapping
      end

      def execute
        result_to_response_type_mapping[result.class]
      end
    end
  end
end


