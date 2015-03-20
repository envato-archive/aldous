require 'aldous/respondable/base'

module Aldous
  module Respondable
    class SendData < Base
      def action(controller)
        SendDataAction.new(data, options, controller, view_data)
      end

      def data
        raise Errors::UserError.new("SendData objects must define a 'data' method")
      end

      def options
        raise Errors::UserError.new("SendData objects must define an 'options' method")
      end

      private

      class SendDataAction
        attr_reader :controller, :view_data, :data, :options

        def initialize(data, options, controller, view_data)
          @controller = controller
          @view_data = view_data
          @data = data
          @options = options
        end

        def execute
          controller.send_data data, options
        end
      end
    end
  end
end
