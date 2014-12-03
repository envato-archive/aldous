require 'aldous/result/base'

module Aldous
  module Result
    class ServerError < Base
      def server_error?
        true
      end
    end
  end
end
