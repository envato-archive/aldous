class SignUpsController < ApplicationController
  include Aldous::Controller

  controller_actions :new, :create
end
