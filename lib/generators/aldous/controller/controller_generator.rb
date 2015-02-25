require 'rails/generators/base'

module Aldous
  module Generators
    class Controller < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :controller_name_argument, type: :string
      argument :base_controller_name_argument, type: :string, default: 'ApplicationController'

      def create_controller_file
        template 'controller.rb.erb', "app/controllers/#{file_path}/#{file_name}.rb"
      end

      private

      def fully_qualified_controller_name
        controller_name_argument.classify
      end

      def fully_qualified_base_controller_name
        base_controller_name_argument.classify
      end

      def file_name
        controller_name_argument.underscore.split('/').last
      end

      def file_path
        controller_name_argument.underscore.split('/')[0...-1].join('/')
      end

      def class_name_without_controller
        fully_qualified_controller_name.to_s.gsub(/Controller$/, '')
      end
    end
  end
end
