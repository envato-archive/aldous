class TodosController::Edit < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user
    return build_view(Todos::NotFoundView, todo_id: params[:id]) unless todo
    return build_view(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    build_view(Todos::EditView)
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end
end
