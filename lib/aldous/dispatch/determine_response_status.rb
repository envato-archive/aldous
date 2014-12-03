module Aldous
  module Dispatch
    class DetermineResponseStatus
      attr_reader :result

      def initialize(result)
        @result = result
      end

      def execute
        result_to_status[result.class] || :unprocessable_entity
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


