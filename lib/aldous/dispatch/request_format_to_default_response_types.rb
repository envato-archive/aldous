require 'aldous/dispatch/default_html_response_types'
require 'aldous/dispatch/default_json_response_types'
require 'aldous/dispatch/default_atom_response_types'

module Aldous
  module Dispatch
    class RequestFormatToDefaultResponseTypes
      def default_response_types_for(format)
        {
          :html => DefaultHtmlResponseTypes.new,
          :json => DefaultJsonResponseTypes.new,
          :atom => DefaultAtomResponseTypes.new,
        }[format]
      end
    end
  end
end
