class Todos::IndexRedirect < Aldous::Respondable::Redirectable
  def location
    view_context.todos_path
  end
end
