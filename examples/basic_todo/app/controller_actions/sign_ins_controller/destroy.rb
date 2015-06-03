class SignInsController::Destroy < BaseAction
  def perform
    return view_builder.build(Home::ShowRedirect) unless current_user

    SignOutService.perform!(session)

    view_builder.build(Home::ShowRedirect)
  end
end
