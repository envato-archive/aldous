require 'aldous/controller/action/precondition/wrapper'

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

        #def method_missing(method_sym, *arguments, &block)
          #if action.respond_to?(method_sym)
            #self.singleton_class.class_exec(method_sym, action) do |method_name, action|
              #define_method method_name do
                #action.send(method_name)
              #end
            #end
            #send(method_sym)
          #else
            #super
          #end
        #end

        #def respond_to?(method_sym, include_private = true)
          #if action.respond_to?(method_sym)
            #true
          #else
            #super
          #end
        #end
      end
    end
  end
end
