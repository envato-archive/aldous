require 'aldous/respondable/base'
require 'aldous/controller/action/precondition/wrapper'

module Aldous
  module Controller
    class PreconditionsExecutionService
      attr_reader :action_wrapper, :controller

      def initialize(action_wrapper, controller)
        @action_wrapper = action_wrapper
        @controller = controller
      end

      def perform
        if action_wrapper.respond_to?(:preconditions) && !action_wrapper.preconditions.empty?
          action_wrapper.preconditions.each do |precondition_class|
            action = action_wrapper.controller_action
            precondition = precondition_class.build(action, controller, action.view_builder)
            precondition_result = precondition.perform

            if precondition_result.kind_of?(::Aldous::Respondable::Base)
              return [precondition, precondition_result]
            end
          end
        end
        [nil, nil]
      end
    end
  end
end

