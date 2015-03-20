require 'aldous/logging_wrapper'

module Aldous
  class Params
    include Aldous

    class << self
      def build(*args)
        new(*args)
      end
    end

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def fetch
      permitted_params
    rescue => e
      Aldous::LoggingWrapper.log(e)
      nil
    end

    def permitted_params
      {}
    end

    def error_message
      'Missing param'
    end
  end
end
