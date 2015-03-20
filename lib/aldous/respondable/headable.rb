require 'aldous/respondable/base'

module Aldous
  module Respondable
    class Headable < Base
      def action(controller)
        HeadAction.new(controller, status)
      end

      def default_status
        :ok
      end

      private

      class HeadAction
        attr_reader :controller, :status

        def initialize(controller, status)
          @controller = controller
          @status = status
        end

        def execute
          controller.head status
        end
      end
    end
  end
end
