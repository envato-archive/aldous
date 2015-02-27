class SignInsController::DestroyService < BaseControllerService
  def preconditions
    super + [
      SignedInUserPresentPrecondition.new(current_user)
    ]
  end

  def perform
    sign_out
    Result::Success.new
  end

  private

  def sign_out
    controller.sign_out
  end
end
