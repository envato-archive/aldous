class Todos::AllCompletedController::Destroy < BaseAction
  def perform
    return build_view(Home::ShowRedirect) unless current_user

    if todos.destroy_all
      build_view(Todos::IndexRedirect)
    else
      build_view(Defaults::ServerErrorView, errors: ['Unable to delete completed todos'])
    end
  end

  private

  def todos
    @todo ||= Todo.where(user_id: current_user.id).where(done: true)
  end
end
