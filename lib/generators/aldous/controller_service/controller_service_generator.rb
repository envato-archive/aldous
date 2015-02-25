require 'rails/generators/base'

module Aldous
  module Generators
    class ControllerService < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      argument :service_name_argument, :type => :string

      def create_controller_service
        template "controller_service.rb.erb", "app/controller_services/#{file_path}/#{file_name}.rb"
      end

      private

      def file_name
        service_name_argument.underscore.split('/').last
      end

      def file_path
        service_name_argument.underscore.split('/')[0...-1].join('/')
      end

      def service_name
        full_qualified_service_name.split("::").last
      end

      def full_qualified_service_name
        service_name_argument.classify
      end

      def controller_class_name
        @controller_class ||= full_qualified_service_name.split('::')[0...-1].join('::')
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
