module Aldous
  module Service
    module PerformWithRescue
      def self.included(base)
        # we prepend a module into the base class so that we can use super
        # inside the methods in that module to delegate to methods with
        # the same name on the class e.g. the perform method in the
        # PrependedMethods module below calls super which will delegate to
        # the perform method of the class where the ControllerService module
        # is included
        base.prepend PrependedMethods
      end

      module PrependedMethods
        def perform
          check_preconditions_result = ::CheckPreconditions.new(preconditions).perform
          return check_preconditions_result unless check_preconditions_result.success?

          if defined?(super)
            super
          else
            raise "#{self.class.name} must implement the 'perform' method"
          end
        rescue => e
          ErrorReporter.report(e)
          return ::Service::ServerErrorResult.new(error: e.message)
        end
      end
    end
  end
end
