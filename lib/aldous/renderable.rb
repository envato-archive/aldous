require 'aldous/respondable'
require 'aldous/response_action/render'

module Aldous
  module Renderable
    include Respondable

    def action(controller)
      ::Aldous::ResponseAction::Render.new(template, controller, result)
    end

    def template
      raise RuntimeError.new("Renderable objects must define a 'template' method")
    end
  end
end
