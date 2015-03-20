class TodosController::Index < BaseAction
  def default_view_data
    super.merge({todos: todos})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user

    build_view(Todos::IndexView)
  end

  private

  def todos
    Todo.where(user_id: current_user.id)
  end
end


