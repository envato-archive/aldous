class SignInsController::Destroy < BaseAction
  def perform
    return build_view(Home::ShowRedirect) unless current_user

    SignOutService.perform!(session)

    build_view(Home::ShowRedirect)
  end
end
