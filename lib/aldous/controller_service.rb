require 'forwardable'
require 'aldous/controller_service/wrapper'

module Aldous
  class ControllerService
    include Aldous

    class << self
      def build(controller)
        Aldous::ControllerService::Wrapper.new(new(controller))
      end

      def perform(controller)
        build(controller).perform
      end

      def inherited(klass)
        # expose methods from controller to the service, according to configuration
        ::Aldous.configuration.controller_methods_exposed_to_controller_service.each do |method_name|
          unless klass.method_defined?(method_name)
            define_method method_name do
              controller.send(method_name)
            end
          end
        end
      end
    end

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def perform
      raise NotImplementedError.new("#{self.class.name} must implement method #perform")
    end

    def default_result_options
      {}
    end

    def preconditions
      []
    end
  end
end
