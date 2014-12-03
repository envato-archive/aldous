require 'aldous/result'
require 'aldous/result/precondition_failure'

module Aldous
  module Service
    module Precondition
      # when the module is included we create a FailureResult class named after
      # the procondition inside the services module e.g. if the precondition
      # is called BlahPresentPrecondition we will get a new result class called
      # BlahPresentPreconditionFailureResult, this new result lives
      # inside the Service module like all the other results
      def self.included(base)
        failure_result_class_name = "#{base.name.split('::').last}Failure"
        unless ::Aldous::Result.const_defined?(failure_result_class_name)
          ::Aldous::Result.const_set(failure_result_class_name, Class.new(::Aldous::Result::PreconditionFailure))
        end
      end
    end
  end
end

