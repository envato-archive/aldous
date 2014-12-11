module Aldous
  module Respondable
    attr_reader :result, :view_context

    def initialize(result, view_context)
      @result = result
      @view_context = view_context
    end
  end
end
