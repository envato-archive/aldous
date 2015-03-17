class TodosController::Update < BaseAction
  def default_view_data
    super.merge({todo: todo})
  end

  def perform
    return build_view(Home::ShowRedirect) unless current_user
    return build_view(Defaults::BadRequestView, errors: [todo_params.error_message]) unless todo_params.fetch
    return build_view(Todos::NotFoundView, todo_id: params[:id]) unless todo
    return build_view(Defaults::ForbiddenView) unless current_ability.can?(:update, todo)

    if todo.update_attributes(todo_params.fetch)
      build_view(Todos::IndexRedirect)
    else
      build_view(Todos::EditView)
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
