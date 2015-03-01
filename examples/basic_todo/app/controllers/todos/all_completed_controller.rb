class Todos::AllCompletedController < ApplicationController
  include Aldous::Controller

  controller_actions :destroy
end
