require 'aldous/respondable/base'
require 'aldous/respondable/shared/flash'

module Aldous
  module Respondable
    class Renderable < Base
      def action(controller)
        RenderAction.new(template, controller, result)
      end

      def template
        raise Errors::UserError.new("Renderable objects must define a 'template' method")
      end

      def template_with_locals(extra_locals = {})
        if template.kind_of?(Hash)
          template.tap do |t|
            t[:locals] ||= {}
            t[:locals] = t[:locals].merge(extra_locals || {})
          end
        else
          raise Errors::UserError.new("'template' method must return a Hash")
        end
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
