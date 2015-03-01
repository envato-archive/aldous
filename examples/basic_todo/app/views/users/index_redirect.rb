class Users::IndexRedirect < Aldous::Respondable::Redirectable
  def location
    view_context.root_path
  end
end
