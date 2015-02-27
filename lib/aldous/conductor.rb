require 'aldous'

module Aldous
  class Conductor
    class MissingPreconditionFailureMappingError < StandardError;
    end

    class << self
      def perform(controller, controller_service_class, mapping)
        self.new(controller, controller_service_class, mapping).perform
      end
    end

    attr_reader :controller, :controller_service_class, :mapping

    def initialize(controller, controller_service_class, mapping)
      @controller = controller
      @controller_service_class = controller_service_class
      @mapping    = mapping
    end

    def perform
      service = controller_service_class.build(controller)
      validate_mapping!(service)
      service.perform.tap do |result|
        p "*****************"
        p mapping
        p result
        Aldous::ResultDispatcher.execute(controller, result, mapping)
      end
    end

    private

    def validate_mapping!(service)
      ensure_all_members_are_classes
      ensure_precondition_failures_handled(service)
    end

    def ensure_all_members_are_classes
      mapping.to_a.flatten.each do |x|
        raise ArgumentError.new("All members of the mapping must be classes -- #{x}") unless x.is_a?(Class)
      end
    end

    def ensure_precondition_failures_handled(service)
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
  end
end
