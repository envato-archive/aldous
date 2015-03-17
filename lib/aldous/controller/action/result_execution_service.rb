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
          ::Aldous::LoggingWrapper.log(e)
        end
      end
    end
  end
end
