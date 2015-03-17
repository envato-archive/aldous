require 'aldous/controller/action/wrapper'
require 'aldous/view/blank/html_view'
require 'aldous/simple_dto'
require 'aldous/build_respondable_service'

module Aldous
  class ControllerAction
    include Aldous

    class << self
      def build(controller)
        Aldous::Controller::Action::Wrapper.new(new(controller))
      end

      def perform(controller)
        build(controller).perform
      end

      def inherited(klass)
        # expose methods from controller to the service, according to configuration
        ::Aldous.configuration.controller_methods_exposed_to_action.each do |method_name|
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

    def default_view_data
      {}
    end

    def preconditions
      []
    end

    def default_error_respondable
      ::Aldous::View::Blank::HtmlView
    end

    def build_view(respondable_class, status = nil, extra_data = {})
      ::Aldous::BuildRespondableService.new(
        view_context: controller.view_context,
        default_view_data: default_view_data,
        respondable_class: respondable_class,
        status: status,
        extra_data: extra_data
      ).perform
    end
  end
end
