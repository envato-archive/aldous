class TodosController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user
    return build_view(Defaults::BadRequestView, errors: [todo_params.error_message]) unless todo_params.fetch

    if todo.save
      build_view(Todos::IndexRedirect)
    else
      build_view(Todos::NewView)
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
