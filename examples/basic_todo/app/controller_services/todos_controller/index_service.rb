class TodosController::IndexService < BaseControllerService
  def default_result_options
    super.merge({todos: todos})
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

  def todos
    Todo.where(user_id: current_user.id)
  end
end

