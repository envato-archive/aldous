require 'aldous/response_action/head'

module Aldous
  module Headable
    def action(controller)
      ::Aldous::ResponseAction::Head.new(controller)
    end
  end
end
