require 'aldous/dispatch/request_format_to_default_response_types'
require 'aldous/dispatch/determine_response_status'
require 'aldous/result/server_error'
require 'aldous/controller_data'

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
        response_type_class.new(result, controller.view_context).action.execute(response_status)
      rescue
        # final fallback so we can blow up gracefully
        controller.head :unprocessable_entity
      end

      private

      def response_type_class
        @response_type_class ||= default_response_types.response_type_for(result.class)
      end

      def default_response_types
        @default_response_types ||= RequestFormatToDefaultResponseTypes.new.default_response_types_for(request_format)
      end

      def response_status
        @response_status ||= DetermineResponseStatus.new(result).execute
      end

      def result
        @result ||= ::Aldous::Result::ServerError.new(error: error)
      end

      def request_format
        @request_format ||= ::Aldous::ControllerData.new(controller).request_format
      end
    end
  end
end
