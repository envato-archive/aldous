require 'aldous/version'

require 'aldous/configuration'

require 'aldous/respondable'
require 'aldous/headable'
require 'aldous/redirectable'
require 'aldous/renderable'
require 'aldous/send_data'

require 'aldous/result_dispatcher'

require 'aldous/result/failure'
require 'aldous/result/not_found'
require 'aldous/result/precondition_failure'
require 'aldous/result/server_error'
require 'aldous/result/success'
require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'

require 'aldous/controller_service'
require 'aldous/controller_service/perform_with_rescue'
require 'aldous/controller_service/precondition'
require 'aldous/controller_service/check_preconditions'
require 'aldous/controller_service/param_present_precondition'

require 'aldous/view/blank/atom_view'
require 'aldous/view/blank/json_view'
require 'aldous/view/blank/html_view'

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
