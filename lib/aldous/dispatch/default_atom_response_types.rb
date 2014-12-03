module Aldous
  module Dispatch
    class DefaultAtomResponseTypes
      def response_type_for(result_class)
        {
          ::Aldous::Result::Unauthenticated   => ::Aldous::View::BlankAtomView,
          ::Aldous::Result::Unauthorized      => ::Aldous::View::BlankAtomView,
          ::Aldous::Result::NotFound          => ::Aldous::View::BlankAtomView,
          ::Aldous::Result::ServerError       => ::Aldous::View::BlankAtomView,
        }[result_class]
      end
    end
  end
end

