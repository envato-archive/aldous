class SignInsController::NewService < BaseControllerService
  def preconditions
    super + [
      SignedInUserNotPresentPrecondition.new(current_user)
    ]
  end

  def perform
    Result::Success.new
  end
end

