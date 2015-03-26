class HomeController::Show < BaseAction
  def perform
    return build_view(Todos::IndexRedirect) if current_user
    build_view(Home::ShowView)
  end
end

