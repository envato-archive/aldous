class TodosController::DestroyService < BaseControllerService
  def default_result_options
    super.merge({todo: todo})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user),
    ]
  end

  def perform
    return Result::NotFound.new(errors: ["No todo with id #{params[:id]}, for user #{current_user.email}"]) unless todo

    todo.destroy

    Result::Success.new
  end

  private

  def todo
    @todo ||= Todo.where(id: params[:id]).first
  end
end

