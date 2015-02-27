class SignUpsController < ApplicationController
  include Aldous::Controller

  def new
    Conductor.perform(self, NewService, {
      Result::Success => SignUps::NewView,
    })
  end

  def create
    Conductor.perform(self, CreateService, {
      Result::Success                   => Todos::IndexRedirect,
      Result::Failure                   => SignUps::NewView,
      ParamPresentPrecondition::Failure => Defaults::ServerErrorView
    })
  end
end
