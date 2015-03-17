require 'aldous/controller/action/precondition/wrapper'
require 'aldous/build_respondable_service'

module Aldous
  module Controller
    module Action
      class Precondition
        include Aldous

        class << self
          def build(action)
            Aldous::Controller::Action::Precondition::Wrapper.new(new(action))
          end

          def perform(action)
            build(action).perform
          end

          def inherited(klass)
            ::Aldous.configuration.controller_methods_exposed_to_action.each do |method_name|
              unless klass.method_defined?(method_name)
                define_method method_name do
                  action.controller.send(method_name)
                end
              end
            end
          end
        end

        attr_reader :action

        def initialize(action)
          @action = action
        end

        def perform
          raise NotImplementedError.new("#{self.class.name} must implement method #perform")
        end

        def build_view(respondable_class, status = nil, extra_data = {})
          ::Aldous::BuildRespondableService.new(
            view_context: action.controller.view_context,
            default_view_data: action.default_view_data,
            respondable_class: respondable_class,
            status: status,
            extra_data: extra_data
          ).perform
        end
      end
    end
  end
end
