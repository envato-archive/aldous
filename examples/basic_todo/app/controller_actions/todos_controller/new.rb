class TodosController::New < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user

    view_builder.build(Todos::NewView)
  end

  private

  def todo
    @todo ||= Todo.new(user_id: current_user.id)
  end
end
