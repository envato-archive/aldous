require 'aldous/result/base'

module Aldous
  module Result
    class NotFound < Base
      def not_found?
        true
      end
    end
  end
end


