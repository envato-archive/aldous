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
          complete_respondable.action(controller).execute
        end

        private

        def complete_respondable
          @complete_respondable ||= update_respondable_with_default_view_data
        end

        def update_respondable_with_default_view_data
          status            = respondable.status
          extra_data        = respondable.view_data._data
          actual_extra_data = default_view_data.merge(extra_data)
          view_data         = SimpleDto.new(actual_extra_data)

          respondable.class.new(status, view_data, controller.view_context)
        end
      end
    end
  end
end
