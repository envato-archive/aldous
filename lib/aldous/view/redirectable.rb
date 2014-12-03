require 'aldous/response_action/redirect'

module Aldous
  module View
    module Redirectable
      def action(controller)
        ::Aldous::ResponseAction::Redirect.new(controller, result)
      end
    end
  end
end
