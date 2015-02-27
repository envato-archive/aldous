class Todos::CompletedController::CreateService < BaseControllerService
  def default_result_options
    super.merge({todo: todo})
  end

  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user),
    ]
  end

  def perform
    return Result::NotFound.new(errors: ["No todo with id #{todo_id}, for user #{current_user.email}"]) unless todo

    todo.done = true

    if todo.save
      Result::Success.new
    else
      Result::Failure.new(errors: 'Unable to save todo for some reason')
    end
  end

  private

  def todo
    @todo ||= Todo.where(id: todo_id).first
  end

  def todo_id
    params[:todo_id]
  end
end

