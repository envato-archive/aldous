require 'aldous/respondable/base'
require 'aldous/respondable/shared/flash'

module Aldous
  module Respondable
    class Renderable < Base
      def action(controller)
        RenderAction.new(template, controller, result)
      end

      def template
        raise RuntimeError.new("Renderable objects must define a 'template' method")
      end

      private

      class RenderAction
        attr_reader :template, :controller, :result

        def initialize(template, controller, result)
          @template = template
          @controller = controller
          @result = result
        end

        def execute(response_status = nil)
          Shared::Flash.new(result, controller.flash.now).set_error
          controller.render template.merge(response_options(response_status))
        end

        private

        def response_options(response_status)
          response_status ? {status: (response_status || :ok)} : {}
        end
      end
    end
  end
end
