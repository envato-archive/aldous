class TodosController < ApplicationController
  include Aldous::Controller

  def index
    Conductor.perform(self, IndexService, {
      Result::Success                           => Todos::IndexView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end

  def new
    Conductor.perform(self, NewService, {
      Result::Success                           => Todos::NewView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end

  def create
    Conductor.perform(self, CreateService, {
      Result::Success                           => Todos::IndexRedirect,
      Result::Failure                           => Todos::NewView,
      ParamPresentPrecondition::Failure         => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end

  def edit
    Conductor.perform(self, EditService, {
      Result::Success                           => Todos::EditView,
      Result::NotFound                          => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end

  def update
    Conductor.perform(self, UpdateService, {
      Result::Success                           => Todos::IndexRedirect,
      Result::Failure                           => Todos::EditView,
      Result::NotFound                          => Defaults::ServerErrorView,
      ParamPresentPrecondition::Failure         => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end

  def destroy
    Conductor.perform(self, DestroyService, {
      Result::Success                           => Todos::IndexRedirect,
      Result::NotFound                          => Defaults::ServerErrorView,
      SignedInUserPresentPrecondition::Failure  => Home::ShowRedirect
    })
  end
end
