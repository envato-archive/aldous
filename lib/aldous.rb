require 'aldous/version'

require 'aldous/configuration'

require 'aldous/errors/user_error'

require 'aldous/respondable'
require 'aldous/headable'
require 'aldous/redirectable'
require 'aldous/renderable'
require 'aldous/send_data'
require 'aldous/controller_sugar'
require 'aldous/with_controller_sugar'

require 'aldous/result_dispatcher'

require 'aldous/result/failure'
require 'aldous/result/not_found'
require 'aldous/result/precondition_failure'
require 'aldous/result/strong_params_failure'
require 'aldous/result/server_error'
require 'aldous/result/success'
require 'aldous/result/unauthenticated'
require 'aldous/result/unauthorized'

require 'aldous/service/error_raising'
require 'aldous/service/validating'
require 'aldous/service/method_object'

require 'aldous/controller_service/params_constructor'
require 'aldous/controller_service/default_result_options'
require 'aldous/controller_service/has_strong_params'
require 'aldous/controller_service/has_preconditions'
require 'aldous/controller_service/perform_with_rescue'
require 'aldous/controller_service/precondition'
require 'aldous/controller_service/check_preconditions'
require 'aldous/controller_service/param_present_precondition'

require 'aldous/response_action/render'
require 'aldous/response_action/redirect'
require 'aldous/response_action/send_data'
require 'aldous/response_action/head'
require 'aldous/response_action/flash'
require 'aldous/response_action/request_http_basic_authentication'

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
