class Todos::CompletedController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user
    return build_view(Todos::NotFoundView, todo_id: todo_id) unless todo
    return build_view(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    todo.done = true

    if todo.save
      build_view(Todos::IndexRedirect)
    else
      build_view(Defaults::ServerErrorView, errors: ["Unable to mark todo completed"])
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
