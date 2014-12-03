require 'aldous/dispatch/handle_error'
require 'aldous/dispatch/request_format_to_default_response_types'
require 'aldous/controller_data'
require 'aldous/dispatch/determine_response_type'
require 'aldous/dispatch/determine_response_status'

module Aldous
  class ResultDispatcher
    attr_reader :controller, :result, :result_to_response_type_mapping

    def initialize(controller, result, result_to_response_type_mapping)
      @controller = controller
      @result = result
      @result_to_response_type_mapping = result_to_response_type_mapping
    end

    def perform
      action_response_type_class = response_type_class || determine_response_type.execute
      response_status = determine_response_status.execute
      action_response_type_class.new(result, controller.view_context).action(controller).execute(response_status)
    rescue => e
      HandleDispatchError.new(e, controller).perform
    end

    private

    def response_type_class
      @response_type_class ||= default_response_types.response_type_for(result.class)
    end

    def default_response_types
      @default_response_types ||= Dispatch::RequestFormatToDefaultResponseTypes.new.default_response_types_for(request_format)
    end

    def request_format
      @request_format ||= ::Aldous::ControllerData.new(controller).request_format
    end

    def determine_response_type
      @result_to_response_type ||= Dispatch::DetermineResponseType.new(result, result_to_response_type_mapping)
    end

    def determine_response_status
      @result_to_response_status ||= Dispatch::DetermineResponseStatus.new(result)
    end
  end
end
