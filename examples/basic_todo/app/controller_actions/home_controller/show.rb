class HomeController::Show < BaseAction
  def perform
    return Todos::IndexRedirect.build if current_user
    Home::ShowView.build
  end
end

