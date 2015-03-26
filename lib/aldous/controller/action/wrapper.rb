require 'aldous/logging_wrapper'
require 'aldous/respondable/base'

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

        def default_error_handler(error)
          controller_action.default_error_handler(error)
        end

        def controller
          controller_action.controller
        end

        def perform
          controller_action.perform
        rescue => e
          ::Aldous::LoggingWrapper.log(e)

          error_handler = default_error_handler(e)

          if error_handler.kind_of?(Class) &&
            error_handler.ancestors.include?(Aldous::Respondable::Base)
            controller_action.build_view(error_handler, errors: [e])
          end
        end
      end
    end
  end
end
