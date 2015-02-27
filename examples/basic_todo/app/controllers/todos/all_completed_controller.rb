class Todos::AllCompletedController < ApplicationController
  include Aldous::Controller

  def destroy
    p "***********************"
    Conductor.perform(self, DestroyService, {
      Result::Success                           => Todos::IndexRedirect,
      Result::Failure                           => Defaults::ServerErrorView,
      ParamPresentPrecondition::Failure         => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end
end
