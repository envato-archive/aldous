class SignUpsController::New < BaseAction
  def perform
    return Todos::IndexRedirect.build if current_user

    return SignUps::NewView.build
  end
end
