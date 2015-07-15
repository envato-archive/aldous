require 'aldous/view_builder'
require 'aldous/logging_wrapper'

module Aldous
  module Controller
    module Action
      class ResultExecutionService
        class << self
          def perform(controller, respondable, default_view_data)
            self.new(controller, respondable, default_view_data).perform
          end
        end

        attr_reader :controller, :respondable, :default_view_data

        def initialize(controller, respondable, default_view_data)
          @controller = controller
          @respondable = respondable
          @default_view_data = default_view_data
        end

        def perform
          respondable.action(controller).execute
        rescue => e
          LoggingWrapper.log(e)
          error_handler = ::Aldous.configuration.error_handler

          if error_handler.kind_of?(Class) && error_handler.ancestors.include?(Aldous::Respondable::Base)
            view_builder.build(error_handler, errors: [e]).action(controller).execute
          else
            controller.head :internal_server_error
          end
        end

        private

        def view_builder
          @view_builder ||= Aldous::ViewBuilder.new(controller.view_context, default_view_data)
        end
      end
    end
  end
end
