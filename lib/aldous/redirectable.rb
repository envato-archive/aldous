require 'aldous/response_action/redirect'

module Aldous
  module Redirectable
    def action(controller)
      ::Aldous::ResponseAction::Redirect.new(controller, result)
    end
  end
end
