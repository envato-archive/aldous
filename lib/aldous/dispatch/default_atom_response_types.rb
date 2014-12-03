module Aldous
  module Dispatch
    class DefaultAtomResponseTypes
      def response_type_for(result_class)
        {
          ::Aldous::Result::Unauthenticated   => ::Aldous::ResponseType::BlankAtomView,
          ::Aldous::Result::Unauthorized      => ::Aldous::ResponseType::BlankAtomView,
          ::Service::NotFoundResult           => ::Controller::ResponseType::BlankAtomView,
          ::Service::ServerErrorResult        => ::Controller::ResponseType::BlankAtomView,
        }[result_class]
      end
    end
  end
end

