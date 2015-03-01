module Aldous
  module Respondable
    class Wrapper
      attr_reader :respondable_class, :status, :dto

      def initialize(respondable_class, status, dto)
        @respondable_class = respondable_class
        @status = status
        @dto = dto
      end

      def build(default_view_data, view_context)
        new_dto = dto.class.new(default_view_data.merge(dto._data))
        respondable_class.new(status, new_dto, view_context)
      end
    end
  end
end
