require 'aldous/simple_dto'

module Aldous
  class ViewBuilder
    attr_reader :view_context, :default_view_data

    def initialize(view_context, default_view_data)
      @view_context = view_context
      @default_view_data = default_view_data
    end

    def build(respondable_class, extra_view_data = {}, status = nil)
      actual_status = status || extra_view_data[:status]
      extra_view_data_no_status = extra_view_data.reject{|k, v| k == :status}
      actual_extra_view_data = default_view_data.merge(extra_view_data_no_status)
      view_data_dto = Aldous::SimpleDto.new(actual_extra_view_data)

      respondable_class.new(actual_status, view_data_dto, view_context)
    end
  end
end
