require 'aldous/result/success'
require 'aldous/result/failure'

module Aldous
  module ControllerService
    module HasStrongParams
      def self.included(base)
        base.class_eval do
          prepend PrependedMethods
        end
      end

      def strong_params
        {}
      end

      module PrependedMethods
        def strong_params
          if defined?(super)
            @strong_params ||= super
          else
            raise "#{self.class.name} must implement the '#{__method__}' method"
          end
        end

        private

        def check_strong_params
          begin
            strong_params
            return Aldous::Result::Success.new
          rescue => e
            ::Aldous.config.error_reporter.report(e)
            return Aldous::Result::Failure.new(error: e.message)
          end
        end
      end
    end
  end
end
