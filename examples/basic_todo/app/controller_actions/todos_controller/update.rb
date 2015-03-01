class TodosController::Update < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user
    return Defaults::BadRequestView.build(errors: [todo_params.error_message]) unless todo_params.fetch
    return Todos::NotFoundView.build(todo_id: params[:id]) unless todo

    if todo.update_attributes(todo_params.fetch)
      Todos::IndexRedirect.build
    else
      Todos::EditView.build
    end
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end

  def todo_params
    TodosController::TodoParams.build(params)
  end
end
