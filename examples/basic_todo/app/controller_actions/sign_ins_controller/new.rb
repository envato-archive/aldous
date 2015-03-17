class SignInsController::New < BaseAction
  def perform
    return build_view(Todos::IndexRedirect) if current_user

    return build_view(SignIns::NewView)
  end
end
