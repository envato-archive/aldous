require 'aldous'
require 'aldous/controller_sugar'

module Aldous
  module WithControllerSugar
    include Aldous
    include ControllerSugar
  end
end