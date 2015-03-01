require 'aldous/respondable/base'

module Aldous
  module Controller
    class PreconditionsExecutionService
      attr_reader :action, :controller

      def initialize(action, controller)
        @action = action
        @controller = controller
      end

      def perform
        if action.respond_to?(:preconditions) && !action.preconditions.empty?
          action.preconditions.each do |precondition_class|
            precondition = precondition_class.build(action.controller_action)
            precondition_result = precondition.perform

            if precondition_result.kind_of?(::Aldous::Respondable::Base) ||
              precondition_result.kind_of?(::Aldous::Respondable::Wrapper)
              return [precondition, precondition_result]
            end
          end
          [nil, nil]
        end
      end
    end
  end
end

