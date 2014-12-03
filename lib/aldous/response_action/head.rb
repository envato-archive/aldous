module Aldous
  module ResponseAction
    class Head
      attr_reader :controller

      def initialize(controller)
        @controller = controller
      end

      def execute(response_status = nil)
        controller.head (response_status || :unprocessable_entity)
      end
    end
  end
end

