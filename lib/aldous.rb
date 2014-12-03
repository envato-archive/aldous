require 'aldous/version'

require 'aldous/configuration'

require 'aldous/controller_data'
require 'aldous/result'
require 'aldous/result_dispatcher'

module Aldous
  class << self
    def configuration(&block)
      @configuration ||= Aldous::Configuration.new
      if block_given?
        block.call(@configuration)
      else
        @configuration
      end
    end
    alias :config :configuration # can use either config or configuration
  end
end
