module Aldous
  module Dispatch
    module Request
      class RequestWrapper
        attr_reader :request

        def initialize(request)
          @request = request
        end

        def format
          (request.format || 'html').to_sym
        end
      end
    end
  end
end
