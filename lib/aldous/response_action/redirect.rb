require 'aldous/response_action/flash'

module Aldous
  module ResponseAction
    class Redirect
      attr_reader :controller, :result, :location, :provided_response_status

      def initialize(location, controller, result, provided_response_status)
        @location = location
        @controller = controller
        @result = result
        @provided_response_status = provided_response_status
      end

      def execute(ignored_response_status = nil)
        ::Aldous::ResponseAction::Flash.for_redirect(controller, result).set_error
        controller.redirect_to location, response_options(provided_response_status)
      end

      private

      def response_options(provided_response_status)
        provided_response_status ? {status: provided_response_status || :found} : {}
      end
    end
  end
end

