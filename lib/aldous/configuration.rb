require 'aldous/dummy_error_reporter'
require 'aldous/dummy_logger'
require 'aldous/stdout_logger'

module Aldous
  class Configuration
    attr_accessor :error_reporter, :default_json_response_types,
      :default_html_response_types, :default_atom_response_types,
      :controller_methods_exposed_to_action,
      :logger

    def initialize
      @error_reporter = ::Aldous::DummyErrorReporter
      @logger = ::Aldous::StdoutLogger
      @default_json_response_types = {}
      @default_html_response_types = {}
      @default_atom_response_types = {}

      @controller_methods_exposed_to_action = [:params, :session, :cookies, :request, :response]
    end
  end
end
