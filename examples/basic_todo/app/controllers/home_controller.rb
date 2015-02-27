class HomeController < ApplicationController
  include Aldous::Controller

  def show
    Conductor.perform(self, ShowService, {
      Result::Success                              => Home::ShowView,
      SignedInUserNotPresentPrecondition::Failure  => Todos::IndexRedirect
    })
  end
end
