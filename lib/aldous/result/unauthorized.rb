require 'aldous/result/base'

module Aldous
  module Result
    class Unauthorized < Base
      def unauthorized?
        true
      end
    end
  end
end
