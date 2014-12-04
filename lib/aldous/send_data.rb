require 'aldous/response_action/send_data'

module Aldous
  module SendData
    def action(controller)
      ::Aldous::ResponseAction::SendData.new(data, options, controller, result)
    end
  end
end
