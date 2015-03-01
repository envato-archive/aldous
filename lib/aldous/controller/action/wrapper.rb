require 'aldous/logging_wrapper'

module Aldous
  module Controller
    module Action
      class Wrapper
        attr :controller_action

        def initialize(controller_action)
          @controller_action = controller_action
        end

        def preconditions
          controller_action.preconditions
        end

        def default_view_data
          controller_action.default_view_data
        end

        def default_error_respondable
          controller_action.default_error_respondable
        end

        def perform
          controller_action.perform
        rescue => e
          ::Aldous::LoggingWrapper.log(e)
          default_error_respondable.build(errors: [e])
        end

        #def method_missing(method_sym, *arguments, &block)
          #if controller_action.respond_to?(method_sym)
            #self.singleton_class.class_exec(method_sym, controller_action) do |method_name, controller_action|
              #define_method method_name do
                #controller_action.send(method_name)
              #end
            #end
            #send(method_sym)
          #else
            #super
          #end
        #end

        #def respond_to?(method_sym, include_private = true)
          #if controller_action.respond_to?(method_sym)
            #true
          #else
            #super
          #end
        #end
      end
    end
  end
end
