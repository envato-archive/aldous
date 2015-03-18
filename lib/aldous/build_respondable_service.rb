require 'aldous/simple_dto'

module Aldous
  class BuildRespondableService
    attr_reader :view_context, :default_view_data
    attr_reader :respondable_class, :status, :extra_data

    def initialize(view_context:, default_view_data:, respondable_class:, status: nil, extra_data: {})
      @view_context = view_context
      @default_view_data = default_view_data
      @respondable_class = respondable_class
      @status = status
      @extra_data = extra_data
    end

    def perform
      # we don't need the status as a local
      actual_extra_data = extra_data.reject{|k, v| k == :status}
      view_data = SimpleDto.new(default_view_data.merge(actual_extra_data))
      respondable_class.new(status, view_data, view_context)
    end
  end
end
