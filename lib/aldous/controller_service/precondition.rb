require 'aldous/result/precondition_failure'
require 'aldous/result'

module Aldous
  class ControllerService
    module Precondition
      include Aldous
      # when the module is included we create a Failure inner class
      # e.g. if the precondition is called BlahPresentPrecondition we will
      # get a new result class called BlahPresentPrecondition::Failure
      def self.included(base)
        failure_result_class_name = "Failure"
        unless base.const_defined?(failure_result_class_name)
          base.const_set(failure_result_class_name, Class.new(::Aldous::Result::PreconditionFailure))
        end
      end

      # Return a success result to continue execution, or return a non-success
      # result to stop execution of the controller service with the type of
      # of (Precondition)Failure as defined above
      def check
        raise "Preconditions must override the 'check' method"
      end
    end
  end
end

