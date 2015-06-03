require 'aldous/logging_wrapper'

module Aldous
  module Controller
    module Action
      class Precondition
        class Wrapper
          attr :precondition

          def initialize(precondition)
            @precondition = precondition
          end

          def default_view_data
            precondition.action.default_view_data
          end

          def default_error_handler(error)
            precondition.action.default_error_handler(error)
          end

          def controller
            precondition.controller
          end

          def view_builder
            precondition.view_builder
          end

          def perform
            precondition.perform
          rescue => e
            ::Aldous::LoggingWrapper.log(e)

            error_handler = default_error_handler(e)

            if error_handler.kind_of?(Class) &&
              error_handler.ancestors.include?(Aldous::Respondable::Base)
              view_builder.build(error_handler, errors: [e])
            end
          end
        end
      end
    end
  end
end
