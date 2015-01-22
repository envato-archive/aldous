require 'aldous/errors/user_error'
require 'aldous/result/failure'
require 'aldous/service/validating'

module Aldous
  module Service
    module ErrorRaising
      include Validating

      def self.included(base)
        # we prepend a module into the base class so that we can use super
        # inside the methods in that module to delegate to methods with
        # the same name on the class e.g. the perform method in the
        # PrependedMethods module below calls super which will delegate to
        # the perform method of the class where this module
        # is included
        base.class_eval do
          prepend PrependedMethods
        end
      end

      def raisable_error
        Aldous::Errors::UserError
      end

      def default_result_options
        {}
      end

      module PrependedMethods
        def perform!
          if defined?(super)
            return super if Aldous.config.test_mode
            begin
              unless validator.valid?
                result = validation_failure_result
                return result.class.new(default_result_options.merge(result._options))
              end
              result = super
              raise "Return value of '#{__method__}' must be a type of #{::Aldous::Result}" unless result.kind_of?(::Aldous::Result::Base)
              result.class.new(default_result_options.merge(result._options))
            rescue => e
              raise raisable_error.new(e.message)
            end
          else
            raise "#{self.class.name} must implement the '#{__method__}' method"
          end
        end

        def perform
          perform!
        rescue => e
          ::Aldous.config.error_reporter.report(e.cause || e)
          ::Aldous::Result::Failure.new(default_result_options.merge(errors: [e]))
        end
      end
    end
  end
end

