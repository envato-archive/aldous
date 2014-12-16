require 'aldous/result/server_error'
require 'aldous/controller_service/default_result_options'
require 'aldous/controller_service/has_strong_params'
require 'aldous/controller_service/has_preconditions'

module Aldous
  module ControllerService
    module PerformWithRescue
      include DefaultResultOptions
      include HasStrongParams
      include HasPreconditions

      def self.included(base)
        # we prepend a module into the base class so that we can use super
        # inside the methods in that module to delegate to methods with
        # the same name on the class e.g. the perform method in the
        # PrependedMethods module below calls super which will delegate to
        # the perform method of the class where the ControllerService module
        # is included
        base.class_eval do
          prepend PrependedMethods
        end
      end

      module PrependedMethods
        def perform
          if defined?(super)
            begin
              check_strong_params_result = check_strong_params
              return check_strong_params_result unless check_strong_params_result.success?

              if preconditions == nil || preconditions.empty?
                return check_preconditions_result unless check_preconditions_result.success?
              end

              # ensure that all results returned always have the default options
              result = super
              result.class.new(default_result_options.merge(result._options))
            rescue => e
              ::Aldous.config.error_reporter.report(e)
              return ::Aldous::Result::ServerError.new(default_result_options.merge(error: e.message))
            end
          else
            raise "#{self.class.name} must implement the 'perform' method"
          end
        end
      end
    end
  end
end
