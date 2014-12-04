require 'aldous/dispatch/request/find_default_response_types'
require 'aldous/dispatch/determine_response_status'
require 'aldous/result/server_error'

module Aldous
  module Dispatch
    class HandleError
      attr_reader :error, :controller

      def initialize(error, controller)
        @error = error
        @controller = controller
      end

      def perform
        ::Aldous.config.error_reporter.report(error)
        response_type_class.new(result, controller.view_context).action(controller).execute(response_status)
      rescue
        # final fallback so we can blow up gracefully
        controller.head :internal_server_error
      end

      private

      def response_type_class
        @response_type_class ||= default_response_types.response_type_for(result.class)
      end

      def default_response_types
        @default_response_types ||= Dispatch::Request::FindDefaultResponseTypes.new(controller.request).execute
      end

      def response_status
        @response_status ||= DetermineResponseStatus.new(result).execute
      end

      def result
        @result ||= ::Aldous::Result::ServerError.new(error: error)
      end
    end
  end
end
