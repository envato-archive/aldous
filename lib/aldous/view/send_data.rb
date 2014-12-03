module SendData
  def action(controller)
    ::Controller::ResponseAction::SendData.new(data, options, controller, result)
  end
end
