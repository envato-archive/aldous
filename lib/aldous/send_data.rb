require 'aldous/respondable'

module Aldous
  module SendData
    include Respondable

    def action(controller)
      ::Aldous::ResponseAction::SendData.new(data, options, controller, result)
    end

    def data
      raise RuntimeError.new("SendData objects must define a 'data' method")
    end

    def options
      raise RuntimeError.new("SendData objects must define an 'options' method")
    end
  end
end
