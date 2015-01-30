require 'aldous/respondable/base'
require 'aldous/respondable/shared/flash'

module Aldous
  module Respondable
    class Redirectable < Base
      def action(controller)
        RedirectAction.new(location, controller, result, status)
      end

      def location
        raise RuntimeError.new("Redirectable objects must define a 'location' method")
      end

      def status
        :found
      end

      private

      class RedirectAction
        attr_reader :controller, :result, :location, :provided_response_status

        def initialize(location, controller, result, provided_response_status)
          @location = location
          @controller = controller
          @result = result
          @provided_response_status = provided_response_status
        end

        def execute(ignored_response_status = nil)
          Shared::Flash.new(result, controller.flash).set_error
          controller.redirect_to location, response_options(provided_response_status)
        end

        private

        def response_options(provided_response_status)
          provided_response_status ? {status: provided_response_status || :found} : {}
        end
      end
    end
  end
end
