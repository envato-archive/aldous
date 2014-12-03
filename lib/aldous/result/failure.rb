require 'aldous/result/base'

module Aldous
  class Result
    class Failure < Base
      def failure?
        true
      end
    end
  end
end


