require 'aldous/logging_wrapper'

module Aldous
  class ControllerAction
    class Wrapper
      attr :controller_action

      def initialize(controller_action)
        @controller_action = controller_action
      end

      def preconditions
        controller_action.preconditions
      end

      def default_view_data
        controller_action.default_view_data
      end

      def default_error_respondable
        controller_action.default_error_respondable
      end

      def perform
        controller_action.perform
      rescue => e
        ::Aldous::LoggingWrapper.log(e)
        default_error_respondable.build(errors: [e])
      end
    end
  end
end
