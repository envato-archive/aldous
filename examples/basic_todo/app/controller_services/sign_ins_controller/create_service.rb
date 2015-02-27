class SignInsController::CreateService < BaseControllerService
  def preconditions
    super + [
      ParamPresentPrecondition.new(params, :user),
      SignedInUserNotPresentPrecondition.new(current_user)
    ]
  end

  def perform
    return Result::NotFound.new unless user

    if user.authenticate(user_params[:password])
      sign_in
      Result::Success.new
    else
      Result::Failure.new
    end
  end

  private

  def user
    @user ||= User.where(email: user_params[:email]).first
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :password)
  end

  def sign_in
    controller.sign_in(user)
  end
end
