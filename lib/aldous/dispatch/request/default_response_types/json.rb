require 'aldous/dispatch/request/default_response_types/mapping'
require 'aldous/view/blank/json_view'

module Aldous
  module Dispatch
    module Request
      module DefaultResponseTypes
        class Json
          include Mapping

          def default_view
            ::Aldous::View::Blank::JsonView
          end
        end
      end
    end
  end
end
