module Aldous
  module Headable
    include Respondable

    def action(controller)
      ::Aldous::ResponseAction::Head.new(controller)
    end
  end
end
