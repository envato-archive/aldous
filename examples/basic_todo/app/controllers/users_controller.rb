class UsersController < ApplicationController
  include Aldous::Controller

  def index
    Conductor.perform(self, IndexService, {
      Success => Users::IndexView,
    })
  end
end
