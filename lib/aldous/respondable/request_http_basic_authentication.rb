module Aldous
  module Respondable
    class RequestHttpBasicAuthentication < Base
      def action(controller)
        RequestHttpBasicAuthenticationAction.new(controller)
      end

      private

      class RequestHttpBasicAuthenticationAction
        attr_reader :controller

        def initialize(controller)
          @controller = controller
        end

        def execute
          controller.request_http_basic_authentication
        end
      end
    end
  end
end
