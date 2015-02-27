class SignInsController < ApplicationController
  include Aldous::Controller

  def new
    Conductor.perform(self, NewService, {
      Result::Success                             => SignIns::NewView,
      SignedInUserNotPresentPrecondition::Failure => Todos::IndexRedirect
    })
  end

  def create
    Conductor.perform(self, CreateService, {
      Result::Success                             => Todos::IndexRedirect,
      Result::Failure                             => SignIns::NewView,
      Result::NotFound                            => SignIns::NewView,
      ParamPresentPrecondition::Failure           => Defaults::ServerErrorView,
      SignedInUserNotPresentPrecondition::Failure => Todos::IndexRedirect,
    })
  end

  def destroy
    Conductor.perform(self, DestroyService, {
      Result::Success                          => Home::ShowRedirect,
      SignedInUserPresentPrecondition::Failure => Home::ShowRedirect,
    })
  end
end
