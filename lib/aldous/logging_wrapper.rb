module Aldous
  class LoggingWrapper
    class << self
      def log(error)
        if error.kind_of?(String)
          ::Aldous.config.error_reporter.report(error)
          ::Aldous.config.logger.info(error)
        else # it's an error object
          ::Aldous.config.error_reporter.report(error)
          ::Aldous.config.logger.info(error.message)
          ::Aldous.config.logger.info(error.backtrace.join("\n"))
        end
      end
    end
  end
end
