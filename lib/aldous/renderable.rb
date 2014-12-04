require 'aldous/response_action/render'

module Aldous
  module Renderable
    def action(controller)
      ::Aldous::ResponseAction::Render.new(template, controller, result)
    end
  end
end
