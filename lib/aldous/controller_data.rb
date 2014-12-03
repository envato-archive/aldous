module Aldous
  class ControllerData
    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def request_format
      (controller.request.format || 'html').to_sym
    end
  end
end
