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

      def default_template_locals
        {}
      end

      def template_data
        {}
      end

      def template(extra_locals = {})
        template_locals = template_data[:locals] || {}
        locals = default_template_locals.merge(template_locals)
        locals = locals.merge(extra_locals || {})
        template_hash = template_data.merge(locals: locals)
        template_hash
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
          Shared::Flash.new(view_data, controller.flash.now).set_error if controller.respond_to?(:flash)
          controller.render template.merge(status: status)
        end
      end
    end
  end
end
