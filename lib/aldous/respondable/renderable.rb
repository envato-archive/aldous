require 'aldous/respondable/base'
require 'aldous/respondable/shared/flash'

module Aldous
  module Respondable
    class Renderable < Base
      def action(controller)
        RenderAction.new(template, status, controller, view_data)
      end

      def default_status
        :ok
      end

      def template
        raise Errors::UserError.new("Renderable objects must define a 'template' method")
      end

      def template_with_locals(extra_locals = {})
        local_template = template
        if local_template.kind_of?(Hash)
          local_template[:locals] ||= {}
          local_template[:locals] = local_template[:locals].merge(extra_locals || {})
          local_template
        else
          raise Errors::UserError.new("'template' method must return a Hash")
        end
      end

      private

      class RenderAction
        attr_reader :template, :controller, :view_data, :status

        def initialize(template, status, controller, view_data)
          @status = status
          @template = template
          @controller = controller
          @view_data = view_data
        end

        def execute
          Shared::Flash.new(view_data, controller.flash.now).set_error
          controller.render template.merge(status: status)
        end
      end
    end
  end
end
