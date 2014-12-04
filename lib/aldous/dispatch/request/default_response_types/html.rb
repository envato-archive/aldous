require 'aldous/dispatch/request/default_response_types/mapping'
require 'aldous/view/blank/html_view'

module Aldous
  module Dispatch
    module Request
      module DefaultResponseTypes
        class Html
          include Mapping

          def default_view
            ::Aldous::View::Blank::HtmlView
          end
        end
      end
    end
  end
end
