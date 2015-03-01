class TodosController::Destroy < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user
    return Todos::NotFoundView.build(todo_id: params[:id]) unless todo

    todo.destroy

    Todos::IndexRedirect.build
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end
end
