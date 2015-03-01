class TodosController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return Home::ShowRedirect.build unless current_user
    return Defaults::BadRequestView.build(errors: [todo_params.error_message]) unless todo_params.fetch

    if todo.save
      Todos::IndexRedirect.build
    else
      Todos::NewView.build
    end
  end

  private

  def todo
    @todo ||= Todo.new(todo_params.fetch)
  end

  def todo_params
    TodosController::TodoParams.build(params)
  end
end
