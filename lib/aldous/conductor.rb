require 'aldous'

module Aldous
  class Conductor
    class MissingPreconditionFailureMappingError < StandardError; end

    attr_reader :controller, :mapping, :service, :result

    def initialize(controller, mapping)
      @controller    = controller
      @mapping       = mapping
    end

    def perform(*args)
      @service = controller_service_class.new(*args)
      validate_mapping!
      @result = service.perform
      Aldous::ResultDispatcher.execute(controller, result, mapping)
    end

    private

    def controller_service_class
      @controller_service_class ||= begin
        service_name  = "#{controller.params[:action].classify}Service"
        controller.class.const_get(service_name)
      end
    end

    def validate_mapping!
      ensure_all_members_are_classes
      ensure_precondition_failures_handled
    end

    def ensure_precondition_failures_handled
      if service.respond_to?(:preconditions) && !service.preconditions.empty?
        required_mapping_keys = service.preconditions.map do |precondition|
          precondition.class.const_get("Failure")
        end

        missing_keys = required_mapping_keys.reject do |key|
          mapping.keys.include?(key)
        end

        raise MissingPreconditionFailureMappingError.new(
          "Some preconditions were defined in the controller service but were " +
          "not present in the result mapping: #{missing_keys.inspect}"
        ) unless missing_keys.empty?
      end
    end

    def ensure_all_members_are_classes
      mapping.to_a.flatten.each do |x|
        raise ArgumentError.new("All members of the mapping must be classes -- #{x}") unless x.is_a?(Class)
      end
    end

  end
end