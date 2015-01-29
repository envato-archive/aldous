module Aldous
  module ResponseAction
    class Render
      attr_reader :template, :controller, :result

      def initialize(template, controller, result)
        @template = template
        @controller = controller
        @result = result
      end

      def execute(response_status = nil)
        ::Aldous::ResponseAction::Flash.for_render(controller, result).set_error
        controller.render template.merge(response_options(response_status))
      end

      private

      def response_options(response_status)
        response_status ? {status: (response_status || :ok)} : {}
      end
    end
  end
end

