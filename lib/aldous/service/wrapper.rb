require 'aldous/result/base'
require 'aldous/result/failure'

module Aldous
  module Service
    class Wrapper
      attr :service

      def initialize(service)
        @service = service
      end

      def perform!
        result = service.perform

        unless result.kind_of?(::Aldous::Result::Base)
          raise "Return value of #perform must be a type of #{::Aldous::Result}"
        end

        build_result_with_default_options(result)
      rescue => e
        raise raisable_error.new(e.message)
      end

      def perform
        perform!
      rescue => e
        ::Aldous.config.error_reporter.report(e.cause || e)
        ::Aldous::Result::Failure.new(service.default_result_options.merge(errors: [e]))
      end

      private

      def build_result_with_default_options(result)
        result.class.new(service.default_result_options.merge(result._options))
      end

      def raisable_error
        service.raisable_error
      end
    end
  end
end
