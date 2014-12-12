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
            response_types = configured_default_response_types
            if configured_default_response_types.nil? ||
              configured_default_response_types.empty?
              response_types = default_response_types
            end
            response_types[result_class]
          end

          def configured_default_response_types
            {}
          end

          def default_view
            raise "You must override the default view"
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
