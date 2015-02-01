require 'aldous/respondable/base'

module Aldous
  module Respondable
    class Headable < Base
      def action(controller)
        HeadAction.new(controller)
      end

      private

      class HeadAction
        attr_reader :controller

        def initialize(controller)
          @controller = controller
        end

        def execute(response_status = nil)
          controller.head (response_status || :unprocessable_entity)
        end
      end
    end
  end
end
