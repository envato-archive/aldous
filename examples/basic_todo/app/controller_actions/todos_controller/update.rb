class TodosController::Update < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user
    return view_builder.build(Defaults::BadRequestView, errors: [todo_params.error_message]) unless todo_params.fetch
    return view_builder.build(Todos::NotFoundView, todo_id: params[:id]) unless todo
    return view_builder.build(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    if todo.update_attributes(todo_params.fetch)
      view_builder.build(Todos::IndexRedirect)
    else
      view_builder.build(Todos::EditView)
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
