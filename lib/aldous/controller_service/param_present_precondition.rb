require 'aldous/controller_service/precondition'
require 'aldous/result/success'
require 'aldous/result/failure'

module Aldous
  module ControllerService
    class ParamPresentPrecondition
      include Aldous::ControllerService::Precondition

      attr_reader :params, :required_param_key

      def initialize(params, required_param_key)
        @params = params
        @required_param_key = required_param_key.to_sym
      end

      def check
        if params.respond_to?(:require)
          params.require(required_param_key)
        else
          raise unless params.has_key?(required_param_key)
        end
        Aldous::Result::Success.new
      rescue
        Aldous::Result::Failure.new(errors: ["Missing #{required_param_key} param"])
      end
    end
  end
end
