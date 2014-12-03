module Renderable
  def action(controller)
    ::Controller::ResponseAction::Render.new(template, controller, result)
  end
end
