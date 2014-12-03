require 'aldous/version'

require 'aldous/configuration'
require 'aldous/controller_data'

require 'aldous/result/failure'
require 'aldous/result/not_found'
require 'aldous/result/precondition_failure'
require 'aldous/result/server_error'
require 'aldous/result/success'
require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'

require 'aldous/service/perform_with_rescue'
require 'aldous/service/precondition'
require 'aldous/service/check_preconditions'

require 'aldous/view/blank_atom_view'
require 'aldous/view/blank_json_view'
require 'aldous/view/headable'
require 'aldous/view/redirectable'
require 'aldous/view/renderable'
require 'aldous/view/send_data'

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
