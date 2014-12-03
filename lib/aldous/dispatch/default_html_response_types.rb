module Aldous
  class Dispatch
    class DefaultHtmlResponseTypes
      def response_type_for(result_class)
        {
          #::Aldous::Result::Unauthenticated       => ::Errors::UnauthenticatedView,
          #::Aldous::Result::Unauthorized          => ::Errors::UnauthorizedView,
          #::Aldous::Result::NotFound              => ::Errors::NotFoundView,
          #::Aldous::Result::ServerError           => ::Errors::ServerErrorView,
        }[result_class]
      end
    end
  end
end

