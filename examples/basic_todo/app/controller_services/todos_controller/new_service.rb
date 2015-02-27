class TodosController::NewService < BaseControllerService
  def default_result_options
    super.merge({todo: todo})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user)
    ]
  end

  def perform
    Result::Success.new
  end

  private

  def todo
    Todo.new(user_id: current_user.id)
  end
end

