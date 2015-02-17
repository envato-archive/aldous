require 'aldous/controller_service/wrapper'

module Aldous
  module ControllerService
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def build(*args)
        Aldous::ControllerService::Wrapper.new(new(*args))
      end

      def perform(*args)
        build(*args).perform
      end
    end

    def perform
      raise NotImplementedError.new("#{self.class.name} must implement method #perform")
    end

    def default_result_options
      {}
    end

    def strong_params
      {}
    end

    def preconditions
      []
    end
  end
end
