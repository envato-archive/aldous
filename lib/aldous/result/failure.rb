require 'aldous/result/base'

module Aldous
  module Result
    class Failure < Base
      def failure?
        true
      end
    end
  end
end


