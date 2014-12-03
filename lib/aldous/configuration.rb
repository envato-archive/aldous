require 'aldous/dummy_error_reporter'

module Aldous
  class Configuration
    attr_accessor :error_reporter

    def initialize
      @error_reporter = ::Aldous::DummyErrorReporter
    end
  end
end
