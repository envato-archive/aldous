class SignUpsController::New < BaseAction
  def perform
    return build_view(Todos::IndexRedirect) if current_user

    return build_view(SignUps::NewView)
  end
end
