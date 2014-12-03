require 'aldous/result/base'

module Aldous
  module Result
    class PreconditionFailure < Base
      def failure?
        true
      end
    end
  end
end
