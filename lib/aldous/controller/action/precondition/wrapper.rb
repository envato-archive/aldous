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

          def default_error_respondable
            precondition.action.default_error_respondable
          end

          def perform
            precondition.perform
          rescue => e
            ::Aldous::LoggingWrapper.log(e)
            default_error_respondable.build(errors: [e])
          end
        end
      end
    end
  end
end
