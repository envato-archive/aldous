class HomeController::Show < BaseAction
  def perform
    return view_builder.build(Todos::IndexRedirect) if current_user
    view_builder.build(Home::ShowView)
  end
end

