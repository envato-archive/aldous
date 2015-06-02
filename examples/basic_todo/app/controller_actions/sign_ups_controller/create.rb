class SignUpsController::Create < BaseAction
  def perform
    return Todos::IndexRedirect.build if current_user
    return Defaults::BadRequestView.build(errors: [user_params.error_message]) unless user_params.fetch

    if create_user_result.success?
      SignInService.perform!(session, create_user_result.user)
      Todos::IndexRedirect.build
    else
      SignUps::NewView.build
    end
  end

  private

  def create_user_result
    @create_user_result ||= CreateUserService.perform(user_params.fetch)
  end

  def user_params
    @user_params ||= ::SignUpsController::UserParams.build(params)
  end
end
