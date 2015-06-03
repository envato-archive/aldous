require 'aldous/view_builder'
require 'aldous/simple_dto'

module Aldous
  module Respondable
    class Base
      attr_reader :view_data, :view_context

      def initialize(status, view_data, view_context, view_builder = nil)
        @status = status
        @view_data = view_data
        @view_context = view_context
        @view_builder = view_builder
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

      def view_builder
        @view_builder ||= ViewBuilder.new(view_context, view_data._data)
      end

      ################################################
      # NOTE deprecated
      ################################################
      def build_view(respondable_class, extra_data = {}) # deprecated
        view_builder.build(respondable_class, extra_data)
      end
    end
  end
end
