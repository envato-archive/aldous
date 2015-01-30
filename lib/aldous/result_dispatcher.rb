require 'aldous/dispatch/handle_error'
require 'aldous/dispatch/request/find_default_response_types'
require 'aldous/dispatch/determine_response_type'
require 'aldous/dispatch/determine_response_status'

require 'aldous/respondable/base'

module Aldous
  class ResultDispatcher
    class << self
      def execute(controller, result, result_to_response_type_mapping)
        self.new(controller, result, result_to_response_type_mapping).perform
      end
    end

    attr_reader :controller, :result, :result_to_response_type_mapping

    def initialize(controller, result, result_to_response_type_mapping)
      @controller = controller
      @result = result
      @result_to_response_type_mapping = result_to_response_type_mapping
    end

    def perform
      response_type_class = determine_response_type.execute
      response_status = determine_response_status.execute

      report_if_response_type_class_not_found(response_type_class)

      response_type_class ||= default_response_type_class

      ensure_response_type_class_exists(response_type_class)

      response_type = response_type_class.new(result, controller.view_context)

      ensure_response_type_implements_the_right_interfaces(response_type)

      response_type.action(controller).execute(response_status)
    rescue => e
      Dispatch::HandleError.new(e, controller).perform
    end

    private

    def report_if_response_type_class_not_found(response_type_class)
      unless response_type_class
        ::Aldous.config.error_reporter.report("Unable to find response type class for #{result.class.name}, will try to use default")
      end
    end

    def ensure_response_type_class_exists(response_type_class)
      unless response_type_class
        raise "No response type class found for #{result.class.name}"
      end
    end

    def ensure_response_type_implements_the_right_interfaces(response_type)
      unless response_type.respond_to?(:action)
        raise "Response type class provided for #{result.class.name} must implement the #action method, i.e. an #{Aldous::Respondable::Base.name} subclass"
      end
    end

    def default_response_type_class
      @default_response_type_class ||= default_response_types.response_type_for(result.class)
    end

    def default_response_types
      @default_response_types ||= Dispatch::Request::FindDefaultResponseTypes.new(controller.request).execute
    end

    def determine_response_type
      @result_to_response_type ||= Dispatch::DetermineResponseType.new(result, result_to_response_type_mapping)
    end

    def determine_response_status
      @result_to_response_status ||= Dispatch::DetermineResponseStatus.new(result)
    end
  end
end
