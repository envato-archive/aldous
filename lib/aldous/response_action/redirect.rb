require 'aldous/response_action/flash'

module Aldous
  module ResponseAction
    class Redirect
      attr_reader :controller, :result, :location

      def initialize(location, controller, result)
        @location = location
        @controller = controller
        @result = result
      end

      def execute(response_status = nil)
        ::Aldous::ResponseAction::Flash.for_redirect(controller, result).set_error
        controller.redirect_to location, response_options(response_status)
      end

      private

      def response_options(response_status)
        response_status ? {status: response_status || 301} : {}
      end
    end
  end
end

