require 'aldous/result/precondition_failure'

module Aldous
  module ControllerService
    module Precondition
      # when the module is included we create a FailureResult class named after
      # the precondition inside the result module e.g. if the precondition
      # is called BlahPresentPrecondition we will get a new result class called
      # BlahPresentPreconditionFailure, this new result lives
      # inside the Result module like all the other results
      def self.included(base)
        failure_result_class_name = "#{base.name.split('::').last}Failure"
        unless ::Aldous::Result.const_defined?(failure_result_class_name)
          ::Aldous::Result.const_set(failure_result_class_name, Class.new(::Aldous::Result::PreconditionFailure))
        end
      end

      # Return a success result to continue execution, or return a non-success
      # result to stop execution of the controller service with the type of
      # of (Precondition)FailureResult as defined above
      def check
        raise "Preconditions must override the 'check' method"
      end
    end
  end
end

