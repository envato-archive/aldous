module Headable
  def action(controller)
    ::Controller::ResponseAction::Head.new(controller)
  end
end
