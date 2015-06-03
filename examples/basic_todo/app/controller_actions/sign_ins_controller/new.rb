class SignInsController::New < BaseAction
  def perform
    return view_builder.build(Todos::IndexRedirect) if current_user

    return view_builder.build(SignIns::NewView)
  end
end
