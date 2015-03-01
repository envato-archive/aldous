require 'aldous/logging_wrapper'
require 'aldous/service/result/failure'

module Aldous
  class Service
    class Wrapper
      attr :service

      def initialize(service)
        @service = service
      end

      def raisable_error
        service.raisable_error
      end

      def default_result_data
        service.default_result_data
      end

      def perform!
        result = service.perform

        build_result_with_default_options(result)
      rescue => e
        raise raisable_error.new(e.message)
      end

      def perform
        perform!
      rescue => e
        Aldous::LoggingWrapper.log(e.cause || e)
        Aldous::Service::Result::Failure.new(default_result_data.merge(errors: [e]))
      end

      private

      def build_result_with_default_options(result)
        result.class.new(default_result_data.merge(result._data))
      end
    end
  end
end
