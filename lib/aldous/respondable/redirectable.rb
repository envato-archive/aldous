require 'aldous/respondable/base'
require 'aldous/respondable/shared/flash'

module Aldous
  module Respondable
    class Redirectable < Base
      def action(controller)
        RedirectAction.new(location, controller, view_data, status)
      end

      def location
        raise Errors::UserError.new("Redirectable objects must define a 'location' method")
      end

      def default_status
        :found
      end

      private

      class RedirectAction
        attr_reader :controller, :view_data, :location, :status

        def initialize(location, controller, view_data, status)
          @location = location
          @controller = controller
          @view_data = view_data
          @status = status
        end

        def execute
          Shared::Flash.new(view_data, controller.flash).set_error
          controller.redirect_to location, {status: status}
        end
      end
    end
  end
end
