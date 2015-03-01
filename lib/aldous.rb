require 'aldous/version'
require 'aldous/configuration'

require 'aldous/errors/user_error'

require 'aldous/respondable/base'
require 'aldous/respondable/headable'
require 'aldous/respondable/redirectable'
require 'aldous/respondable/renderable'
require 'aldous/respondable/send_data'
require 'aldous/respondable/request_http_basic_authentication'

require 'aldous/service/result/failure'
require 'aldous/service/result/success'

require 'aldous/service'

require 'aldous/controller'
require 'aldous/controller_action'
require 'aldous/controller/action/precondition'
require 'aldous/params'

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

