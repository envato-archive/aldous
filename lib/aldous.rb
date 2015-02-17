require 'aldous/version'

require 'aldous/configuration'

require 'aldous/conductor'

require 'aldous/errors/user_error'

require 'aldous/respondable/base'
require 'aldous/respondable/headable'
require 'aldous/respondable/redirectable'
require 'aldous/respondable/renderable'
require 'aldous/respondable/send_data'
require 'aldous/respondable/request_http_basic_authentication'

require 'aldous/result_dispatcher'

require 'aldous/result/failure'
require 'aldous/result/not_found'
require 'aldous/result/precondition_failure'
require 'aldous/result/strong_params_failure'
require 'aldous/result/server_error'
require 'aldous/result/success'
require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'

require 'aldous/service'

require 'aldous/controller_service'
require 'aldous/controller_service/params_constructor'
require 'aldous/controller_service/precondition'
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
