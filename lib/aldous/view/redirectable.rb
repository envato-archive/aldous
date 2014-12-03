module Redirectable
  def action(controller)
    ::Controller::ResponseAction::Redirect.new(controller, result)
  end
end
