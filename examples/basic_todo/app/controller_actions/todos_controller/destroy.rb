class TodosController::Destroy < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user
    return view_builder.build(Todos::NotFoundView, todo_id: params[:id]) unless todo
    return view_builder.build(Defaults::ForbiddenView) unless current_ability.can?(:destroy, todo)

    todo.destroy

    view_builder.build(Todos::IndexRedirect)
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end
end
