require 'aldous/controller_service/check_preconditions_service'

module Aldous
  module ControllerService
    class Wrapper
      attr :controller_service

      def initialize(controller_service)
        @controller_service = controller_service
      end

      def perform
        return check_preconditions_result unless check_preconditions_result.success?

        build_result_with_default_options(controller_service.perform)
      rescue => e
        ::Aldous.config.error_reporter.report(e)
        return ::Aldous::Result::ServerError.new(
          default_result_options.merge(errors: [e])
        )
      end

      private

      def build_result_with_default_options(result)
        result.class.new(default_result_options.merge(result._options))
      end

      def check_preconditions_result
        @check_preconditions_result ||= CheckPreconditionsService.perform(preconditions)
      end

      def default_result_options
        controller_service.default_result_options
      end

      def preconditions
        controller_service.preconditions
      end
    end
  end
end
