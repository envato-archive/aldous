module Aldous
  module ControllerService
    attr_reader :params

    def initialize(params:)
      @params = params
    end
  end
end
