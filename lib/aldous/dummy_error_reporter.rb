module Aldous
  class DummyErrorReporter
    class << self
      def report(e, data = {})
        nil
      end
    end
  end
end
