require 'aldous/result/precondition_failure'
require 'aldous/result/success'
require 'aldous/controller_service/precondition'

module Aldous
  module ControllerService
    class CheckPreconditions
      attr_reader :preconditions

      def initialize(preconditions)
        @preconditions = preconditions
      end

      def perform
        preconditions.each do |precondition|
          ensure_precondition_includes_precondition_module(precondition)
          precondition_result = precondition.check
          unless precondition_result.success?
            specific_result_class = precondition_failure_result(precondition) || ::Aldous::Result::PreconditionFailure
            return specific_result_class.new(precondition_failure_result_options(precondition, precondition_result))
          end
        end
        ::Aldous::Result::Success.new
      end

      private

      def ensure_precondition_includes_precondition_module(precondition)
        unless precondition.kind_of?(::Aldous::ControllerService::Precondition)
          raise "Precondition #{precondition.class} must include the #{::Aldous::ControllerService::Precondition.name} module"
        end
      end

      def precondition_failure_result(precondition)
        precondition.class.const_get('Failure')
      rescue
        nil
      end

      def precondition_failure_result_options(precondition, precondition_result)
        precondition_result._options.merge(cause: precondition_result)
      end
    end
  end
end
