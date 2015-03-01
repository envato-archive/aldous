require 'aldous/service/result/base'

module Aldous
  class Service
    module Result
      class Base < ::Aldous::SimpleDto
        module PredicateMethodsForInheritance
          # For every child class, create a predicate method on the base named
          # after the child that returns false and override the same predicate
          # method on the child to return true. So if the child class is called
          # Failure then we'll have a predicate method called failure? which will
          # return false on the base class and true on the actual child class.
          def inherited(child)
            return if child.name == nil # unnamed class
            child_class_name_as_predicate = "#{underscore(child.name.split("::").last)}?"

            add_predicate_method_to_class(Aldous::Service::Result::Base, child_class_name_as_predicate, false)
            add_predicate_method_to_class(child, child_class_name_as_predicate, true)
          end

          private

          def add_predicate_method_to_class(klass, method_name, method_value)
            unless klass.instance_methods(false).include?(method_name)
              klass.class_eval do
                define_method method_name do
                  method_value
                end
              end
            end
          end

          def underscore(string)
            string.gsub(/::/, '/').
              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
              gsub(/([a-z\d])([A-Z])/,'\1_\2').
              tr("-", "_").
              downcase
          end
        end
      end
    end
  end
end
