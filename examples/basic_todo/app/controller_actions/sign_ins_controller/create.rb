class SignInsController::Create < BaseAction
  def perform
    return Todos::IndexRedirect.build if current_user
    return Defaults::BadRequestView.build(:bad_request, errors: [user_params.error_message]) unless user_params.fetch
    return SignIns::NewView.build(:not_found) unless user

    if user.authenticate(user_params.fetch[:password])
      SignInService.perform!(session, user)
      Todos::IndexRedirect.build
    else
      SignIns::NewView.build(:unprocessable_entity, errors: ["Incorrect credentials"])
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
