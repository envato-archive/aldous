class TodosController::UpdateService < BaseControllerService
  def default_result_options
    super.merge({todo: todo})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user),
      ParamPresentPrecondition.new(params, :todo),
    ]
  end

  def perform
    return Result::NotFound.new(errors: ["No todo with id #{params[:id]}, for user #{current_user.email}"]) unless todo

    if todo.update_attributes(todo_params)
      Result::Success.new
    else
      Result::Failure.new
    end
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end

  def todo_params
    params.fetch(:todo, {}).permit(:description, :user_id)
  end
end

