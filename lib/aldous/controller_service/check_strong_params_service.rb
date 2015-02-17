require 'aldous/service'
require 'aldous/result/success'
require 'aldous/result/strong_params_failure'

module Aldous
  module ControllerService
    class CheckStrongParamsService
      include Aldous::Service

      attr :controller_service

      def initialize(controller_service)
        @controller_service = controller_service
      end

      def perform
        controller_service.strong_params
        Aldous::Result::Success.new
      rescue => e
        ::Aldous.config.error_reporter.report(e)
        Aldous::Result::StrongParamsFailure.new(error: e.message)
      end
    end
  end
end
