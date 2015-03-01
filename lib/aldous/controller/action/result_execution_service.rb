require 'aldous/logging_wrapper'

module Aldous
  module Controller
    module Action
      class ResultExecutionService
        class << self
          def perform(controller, respondable_wrapper, default_view_data)
            self.new(controller, respondable_wrapper, default_view_data).perform
          end
        end

        attr_reader :controller, :respondable_wrapper, :default_view_data

        def initialize(controller, respondable_wrapper, default_view_data)
          @controller = controller
          @respondable_wrapper = respondable_wrapper
          @default_view_data = default_view_data
        end

        def perform
          respondable = respondable_wrapper.build(default_view_data, controller.view_context)
          respondable.action(controller).execute
        rescue => e
          ::Aldous::LoggingWrapper.log(e)
        end
      end
    end
  end
end
