require 'aldous/result/base'

module Aldous
  module Result
    class Unauthenticated < Base
      def unauthenticated?
        true
      end
    end
  end
end
