require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'
require 'aldous/result/not_found'
require 'aldous/result/server_error'
require 'aldous/result/success'
require 'aldous/result/failure'
require 'aldous/result/precondition_failure'

module Aldous
  module Dispatch
    class DetermineResponseStatus
      attr_reader :result

      def initialize(result)
        @result = result
      end

      def execute
        result_class = result.class
        if result.respond_to?(:cause) && result.cause && result.cause.kind_of?(::Aldous::Result::Base)
          result_class = result.cause.class
        end
        result_to_status[result_class] || :internal_server_error
      end

      private

      def result_to_status
        {
          ::Aldous::Result::Unauthenticated       => :unauthorized,
          ::Aldous::Result::Unauthorized          => :unauthorized,
          ::Aldous::Result::NotFound              => :not_found,
          ::Aldous::Result::ServerError           => :internal_server_error,
          ::Aldous::Result::Success               => :ok,
          ::Aldous::Result::Failure               => :unprocessable_entity,
          ::Aldous::Result::PreconditionFailure   => :unprocessable_entity,
        }
      end
    end
  end
end
