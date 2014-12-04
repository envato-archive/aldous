require 'aldous/dispatch/request/default_response_types/mapping'
require 'aldous/view/blank/atom_view'

module Aldous
  module Dispatch
    module Request
      module DefaultResponseTypes
        class Atom
          include Mapping

          def default_view
            ::Aldous::View::Blank::AtomView
          end
        end
      end
    end
  end
end
