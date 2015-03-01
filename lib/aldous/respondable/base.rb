require 'aldous/simple_dto'
require 'aldous/respondable/wrapper'

module Aldous
  module Respondable
    class Base
      class << self
        def build(*arguments)
          arguments ||= []
          dto = SimpleDto.new
          status = nil
          if arguments.first.kind_of?(Hash)
            dto = SimpleDto.new(arguments.first)
          else
            status = arguments.first
            dto = SimpleDto.new(arguments[1] || {})
          end
          Wrapper.new(self, status, dto)
        end
      end

      attr_reader :view_data, :view_context

      def initialize(status, view_data, view_context)
        @status = status
        @view_data = view_data
        @view_context = view_context
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
