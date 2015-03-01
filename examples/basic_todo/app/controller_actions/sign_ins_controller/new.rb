class SignInsController::New < BaseAction
  def perform
    return Todos::IndexRedirect.build if current_user

    return SignIns::NewView.build
  end
end
