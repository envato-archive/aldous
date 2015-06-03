require 'aldous/controller/action/precondition/wrapper'

module Aldous
  module Controller
    module Action
      class Precondition
        include Aldous

        class << self
          def build(action, controller, view_builder)
            Aldous::Controller::Action::Precondition::Wrapper.new(new(action, controller, view_builder))
          end

          def perform(action, controller, view_builder)
            build(action, controller, view_builder).perform
          end

          def inherited(klass)
            ::Aldous.configuration.controller_methods_exposed_to_action.each do |method_name|
              unless klass.method_defined?(method_name)
                define_method method_name do
                  controller.send(method_name)
                end
              end
            end
          end
        end

        attr_reader :action, :controller, :view_builder

        def initialize(action, controller, view_builder)
          @action = action
          @controller = controller
          @view_builder = view_builder
        end

        def perform
          raise NotImplementedError.new("#{self.class.name} must implement method #perform")
        end

        ################################################
        # NOTE deprecated
        ################################################
        def build_view(respondable_class, extra_data = {}) # deprecated
          view_builder.build(respondable_class, extra_data)
        end
      end
    end
  end
end
