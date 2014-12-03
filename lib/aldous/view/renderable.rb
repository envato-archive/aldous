module Aldous
  module View
    module Renderable
      def action(controller)
        ::Aldous::ResponseAction::Render.new(template, controller, result)
      end
    end
  end
end
