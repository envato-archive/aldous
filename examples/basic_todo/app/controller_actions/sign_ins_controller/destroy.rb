class SignInsController::Destroy < BaseAction
  def perform
    return Home::ShowRedirect.build unless current_user

    SignOutService.perform!(session)

    Home::ShowRedirect.build
  end
end
