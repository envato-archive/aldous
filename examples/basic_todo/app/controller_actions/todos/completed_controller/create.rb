class Todos::CompletedController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user
    return view_builder.build(Todos::NotFoundView, todo_id: todo_id) unless todo
    return view_builder.build(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    todo.done = true

    if todo.save
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(Defaults::ServerErrorView, errors: ["Unable to mark todo completed"])
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
