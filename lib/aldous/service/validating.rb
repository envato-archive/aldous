require 'aldous/result/failure'
require 'aldous/dummy_validator'

module Aldous
  module Service
    module Validating
      def validation_failure_result
        result_options = {}
        result_options = default_result_options if self.respond_to?(:default_result_options)
        Aldous::Result::Failure.new(result_options)
      end

      def validator
        Aldous::DummyValidator.new
      end
    end
  end
end

