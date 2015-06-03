class Todos::AllCompletedController::Destroy < BaseAction
  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user

    if todos.destroy_all
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(Defaults::ServerErrorView, errors: ['Unable to delete completed todos'])
    end
  end

  private

  def todos
    @todo ||= Todo.where(user_id: current_user.id).where(done: true)
  end
end
