require 'aldous/simple_dto'

module Aldous
  module Respondable
    class Base
      attr_reader :view_data, :view_context

      def initialize(status, view_data, view_context)
        @status = status
        @view_data = view_data
        @view_context = view_context
      end

      def action(controller)
        raise Errors::UserError.new("Respondables must define an 'action' method")
      end

      def status
        @status || default_status
      end

      def default_status
        :ok
      end

      def build_view(klass, extra_data = {})
        dto = Aldous::SimpleDto.new(view_data._data.merge(extra_data))
        klass.new(status, dto, view_context)
      end
    end
  end
end
