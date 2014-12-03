require 'aldous/result/base'

module Aldous
  module Result
    class Success < Base
      def success?
        true
      end
    end
  end
end
