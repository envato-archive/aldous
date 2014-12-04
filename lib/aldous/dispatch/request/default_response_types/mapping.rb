require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'
require 'aldous/result/not_found'
require 'aldous/result/server_error'

module Aldous
  module Dispatch
    module Request
      module DefaultResponseTypes
        module Mapping
          def response_type_for(result_class)
            (configured_default_response_types || default_response_types)[result_class]
          end

          def configured_default_response_types
          end

          def default_response_types
            {
              ::Aldous::Result::Unauthenticated   => default_view,
              ::Aldous::Result::Unauthorized      => default_view,
              ::Aldous::Result::NotFound          => default_view,
              ::Aldous::Result::ServerError       => default_view,
            }
          end
        end
      end
    end
  end
end
