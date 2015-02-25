require 'rails/generators/base'

module Aldous
  module Generators
    class Precondition < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      argument :precondition_name_argument, :type => :string

      def create_controller_service
        template "precondition.rb.erb", "app/controller_services/#{file_path}/#{file_name}.rb"
      end

      private

      def file_name
        precondition_name_argument.underscore.split('/').last
      end

      def file_path
        precondition_name_argument.underscore.split('/')[0...-1].join('/')
      end

      def precondition_name
        full_qualified_precondition_name.split("::").last
      end

      def full_qualified_precondition_name
        precondition_name_argument.classify
      end

      def controller_class_name
        @controller_class ||= full_qualified_precondition_name.split('::')[0...-1].join('::')
      end

      def base_controller_class_name
        if base_controller_class == Object
          raise "Unable to find base controller for #{controller_class_name}"
        else
          base_controller_class.name
        end
      end

      def base_controller_class
        @base_controller_class ||= controller_class_name.split("::").reduce(Object) {|acc, string| acc.const_get(string)}.superclass
      end
    end
  end
end

