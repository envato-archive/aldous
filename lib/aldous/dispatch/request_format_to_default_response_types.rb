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
