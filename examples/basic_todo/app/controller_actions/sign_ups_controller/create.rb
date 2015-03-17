class SignUpsController::Create < BaseAction
  def perform
    return build_view(Todos::IndexRedirect) if current_user
    return build_view(Defaults::BadRequestView, errors: [user_params.error_message]) unless user_params.fetch

    if user.save
      SignInService.perform!(session, user)
      build_view(Todos::IndexRedirect)
    else
      build_view(SignUps::NewView)
    end
  end

  private

  def user
    @user ||= User.new(user_params.fetch)
  end

  def user_params
    @user_params ||= ::SignUpsController::UserParams.build(params)
  end
end
