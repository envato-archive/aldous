require 'aldous/controller/preconditions_execution_service'
require 'aldous/controller/action/result_execution_service'
require 'aldous/logging_wrapper'

module Aldous
  module Controller
    class ActionExecutionService
      class << self
        def perform(controller, controller_action_class)
          self.new(controller, controller_action_class).perform
        end
      end

      attr_reader :controller, :controller_action_class

      def initialize(controller, controller_action_class)
        @controller = controller
        @controller_action_class = controller_action_class
      end

      def perform
        action = controller_action_class.build(controller)

        precondition_result = PreconditionsExecutionService.new(action).perform

        action_result = nil
        if precondition_result
          action_result = precondition_result
        else
          action_result = action.perform
        end

        Action::ResultExecutionService.perform(controller, action_result, action.default_view_data)
      rescue => e
        LoggingWrapper.log(e)
        controller.head :internal_server_error
      end
    end
  end
end

