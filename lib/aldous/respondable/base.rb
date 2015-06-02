require 'aldous/simple_dto'

module Aldous
  module Respondable
    class Base
      class << self
        def build(extra_data = {})
          status = extra_data[:status]
          actual_extra_data = extra_data.reject{|k, v| k == :status}
          view_data = Aldous::SimpleDto.new(actual_extra_data)

          self.new(status, view_data, view_context)
        end
      end

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

      ################################################
      # NOTE deprecated
      ################################################
      def build_view(klass, extra_data = {}) # deprecated
        dto = Aldous::SimpleDto.new(view_data._data.merge(extra_data))
        klass.new(status, dto, view_context)
      end
    end
  end
end
