class TodosController::CreateService < BaseControllerService
  def default_result_options
    super.merge({todo: todo})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user),
      ParamPresentPrecondition.new(params, :todo)
    ]
  end

  def perform
    if todo.save
      Result::Success.new
    else
      Result::Failure.new
    end
  end

  private

  def todo
    @todo ||= Todo.new(todo_params)
  end

  def todo_params
    params.fetch(:todo, {}).permit(:description, :user_id)
  end
end

