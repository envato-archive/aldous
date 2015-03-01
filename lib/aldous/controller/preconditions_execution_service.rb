require 'aldous/respondable/base'

module Aldous
  module Controller
    class PreconditionsExecutionService
      attr_reader :action

      def initialize(action)
        @action = action
      end

      def perform
        if action.respond_to?(:preconditions) && !action.preconditions.empty?
          action.preconditions.each do |precondition|
            precondition_result = precondition.perform

            return precondition_result if precondition_result.kind_of?(::Aldous::Respondable::Base)
          end
          nil
        end
      end
    end
  end
end

