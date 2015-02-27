class Todos::AllCompletedController::DestroyService < BaseControllerService
  def default_result_options
    super.merge({})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user),
    ]
  end

  def perform
    if todos.destroy_all
      Result::Success.new
    else
      Result::Failure.new(errors: 'Unable to remove completed todos')
    end
  end

  private

  def todos
    @todo ||= Todo.where(user_id: current_user.id).where(done: true)
  end
end

