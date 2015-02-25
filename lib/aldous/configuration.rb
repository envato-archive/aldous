require 'aldous/dummy_error_reporter'

module Aldous
  class Configuration
    attr_accessor :error_reporter, :default_json_response_types,
      :default_html_response_types, :default_atom_response_types,
      :controller_methods_exposed_to_controller_service

    def initialize
      @error_reporter = ::Aldous::DummyErrorReporter
      @default_json_response_types = {}
      @default_html_response_types = {}
      @default_atom_response_types = {}

      @controller_methods_exposed_to_controller_service = [:params]
    end
  end
end
