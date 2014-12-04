require 'aldous/dispatch/request/default_response_types/html'
require 'aldous/dispatch/request/default_response_types/json'
require 'aldous/dispatch/request/default_response_types/atom'
require 'aldous/dispatch/request/request_wrapper'

module Aldous
  module Dispatch
    module Request
      class FindDefaultResponseTypes
        attr_reader :request

        def initialize(request)
          @request = request
        end

        def execute
          {
            :html => DefaultResponseTypes::Html.new,
            :json => DefaultResponseTypes::Json.new,
            :atom => DefaultResponseTypes::Atom.new,
          }[request_wrapper.format]
        end

        private

        def request_wrapper
          @request_wrapper ||= RequestWrapper.new(request)
        end
      end
    end
  end
end
