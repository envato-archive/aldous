class TodosController::Index < BaseAction
  def default_view_data
    super.merge({todos: todos})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user

    view_builder.build(Todos::IndexView)
  end

  private

  def todos
    Todo.where(user_id: current_user.id)
  end
end


