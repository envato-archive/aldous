require 'aldous/respondable/base'

module Aldous
  module Respondable
    class SendData < Base
      def action(controller)
        SendDataAction.new(data, options, controller, result)
      end

      def data
        raise Errors::UserError.new("SendData objects must define a 'data' method")
      end

      def options
        raise Errors::UserError.new("SendData objects must define an 'options' method")
      end

      private

      class SendDataAction
        attr_reader :controller, :result, :data, :options

        def initialize(data, options, controller, result)
          @controller = controller
          @result = result
          @data = data
          @options = options
        end

        def execute(response_status = nil)
          controller.send_data data, options
        end
      end
    end
  end
end
