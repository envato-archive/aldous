class TodosController::New < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user

    Todos::NewView.build
  end

  private

  def todo
    @todo ||= Todo.new(user_id: current_user.id)
  end
end
