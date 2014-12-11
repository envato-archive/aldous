require 'aldous/respondable'
require 'aldous/response_action/redirect'

module Aldous
  module Redirectable
    include Respondable

    def action(controller)
      ::Aldous::ResponseAction::Redirect.new(location, controller, result)
    end

    def location
      raise RuntimeError.new("Redirectable objects must define a 'location' method")
    end
  end
end
