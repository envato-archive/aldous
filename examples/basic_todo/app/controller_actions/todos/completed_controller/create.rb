class Todos::CompletedController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user
    return Todos::NotFoundView.build(todo_id: todo_id) unless todo

    todo.done = true

    if todo.save
      Todos::IndexRedirect.build
    else
      Defaults::ServerErrorView.build(errors: ["Unable to mark todo completed"])
    end
  end

  private

  def todo
    @todo ||= Todo.where(id: todo_id).first
  end

  def todo_id
    params[:todo_id]
  end
end
