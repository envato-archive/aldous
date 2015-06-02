class TodosController::Index < BaseAction
  def default_view_data
    super.merge({todos: todos})
  end

  def perform
    return Home::ShowRedirect.build unless current_user

    Todos::IndexView.build
  end

  private

  def todos
    Todo.where(user_id: current_user.id)
  end
end


