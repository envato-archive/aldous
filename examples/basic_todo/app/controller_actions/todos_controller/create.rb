class TodosController::Create < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user
    return view_builder.build(Defaults::BadRequestView, errors: [todo_params.error_message]) unless todo_params.fetch

    if todo.save
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(Todos::NewView)
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
