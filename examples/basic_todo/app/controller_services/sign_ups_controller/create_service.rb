class SignUpsController::CreateService < BaseControllerService
  def default_result_options
    super.merge({})
  end

  def preconditions
    super + [
      ParamPresentPrecondition.new(params, :user)
    ]
  end

  def perform
    if user.save
      sign_in
      Result::Success.new
    else
      Result::Failure.new
    end
  end

  private

  def user
    @user ||= User.new(user_params)
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :password)
  end

  def sign_in
    controller.sign_in(user)
  end
end

