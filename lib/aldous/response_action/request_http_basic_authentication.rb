module Aldous
  module ResponseAction
    class RequestHttpBasicAuthentication
      attr_reader :controller

      def initialize(controller)
        @controller = controller
      end

      def execute(response_status = nil)
        controller.request_http_basic_authentication
      end
    end
  end
end

