require 'aldous/controller_service/check_preconditions'

module Aldous
  module ControllerService
    module HasPreconditions
      def preconditions
        []
      end

      private

      def check_preconditions_result
        @check_preconditions_result ||= CheckPreconditions.new(preconditions).perform
      end
    end
  end
end
