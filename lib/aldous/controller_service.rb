require 'aldous/controller_service/wrapper'

module Aldous
  class ControllerService
    extend Forwardable

    class << self
      def build(controller)
        Aldous::ControllerService::Wrapper.new(new(controller))
      end

      def perform(controller)
        build(controller).perform
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

    Aldous.configuration.controller_methods_exposed_to_controller_service.each do |method_name|
      def_delegators :controller, method_name
    end
  end
end
