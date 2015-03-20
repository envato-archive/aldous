require 'aldous/logging_wrapper'

module Aldous
  module Controller
    module Action
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
          controller_action.build_view(default_error_respondable, errors: [e])
        end
      end
    end
  end
end
