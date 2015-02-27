class Todos::CompletedController < ApplicationController
  include Aldous::Controller

  def create
    Conductor.perform(self, CreateService, {
      Result::Success                           => Todos::IndexRedirect,
      Result::Failure                           => Defaults::ServerErrorView,
      Result::NotFound                          => Defaults::ServerErrorView,
      ParamPresentPrecondition::Failure         => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end
end
