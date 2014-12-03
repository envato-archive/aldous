module Aldous
  module ResponseAction
    class SendData
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

