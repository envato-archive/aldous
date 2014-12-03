module Aldous
  module Dispatch
    class DefaultJsonResponseTypes
      def response_type_for(result_class)
        {
          ::Aldous::Result::Unauthenticated    => ::Aldous::View::BlankJsonView,
          ::Aldous::Result::Unauthorized       => ::Aldous::View::BlankJsonView,
          ::Aldous::Result::NotFound           => ::Aldous::View::BlankJsonView,
          ::Aldous::Result::ServerError        => ::Aldous::View::BlankJsonView,
        }[result_class]
      end
    end
  end
end

