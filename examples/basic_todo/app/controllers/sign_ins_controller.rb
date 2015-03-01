class SignInsController < ApplicationController
  include Aldous::Controller

  controller_actions :new, :create, :destroy
end
