class TodosController::Edit < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user
    return Todos::NotFoundView.build(todo_id: params[:id]) unless todo
    return Defaults::ForbiddenView.build unless current_ability.can?(:update, todo)

    Todos::EditView.build
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end
end
