class Home::ShowRedirect < Aldous::Respondable::Redirectable
  def location
    view_context.root_path
  end
end
