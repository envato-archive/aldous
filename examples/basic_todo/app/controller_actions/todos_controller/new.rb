class TodosController::New < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user

    build_view(Todos::NewView)
  end

  private

  def todo
    @todo ||= Todo.new(user_id: current_user.id)
  end
end
