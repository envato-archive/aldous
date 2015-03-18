class SignInsController::Create < BaseAction
  def perform
    return build_view(Todos::IndexRedirect) if current_user
    return build_view(Defaults::BadRequestView, status: :bad_request, errors: [user_params.error_message]) unless user_params.fetch
    return build_view(SignIns::NewView, status: :not_found) unless user

    if user.authenticate(user_params.fetch[:password])
      SignInService.perform!(session, user)
      build_view(Todos::IndexRedirect)
    else
      build_view(SignIns::NewView, status: :unprocessable_entity, errors: ["Incorrect credentials"])
    end
  end

  private

  def user_params
    @user_params ||= ::SignInsController::UserParams.build(params)
  end

  def user
    @user ||= User.where(email: user_params.fetch[:email]).first
  end
end
