class Todos::AllCompletedController::Destroy < BaseAction
  def perform
    return Home::ShowRedirect.build unless current_user

    if todos.destroy_all
      Todos::IndexRedirect.build
    else
      Defaults::ServerErrorView.build(errors: ['Unable to delete completed todos'])
    end
  end

  private

  def todos
    @todo ||= Todo.where(user_id: current_user.id).where(done: true)
  end
end
