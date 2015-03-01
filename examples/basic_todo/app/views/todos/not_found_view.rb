class Todos::NotFoundView < Aldous::Respondable::Renderable
  def template
    {
      template: 'todos/not_found',
      locals: {
        header_template: header_template,
        user_email: current_user.email,
        todo_id: view_data.todo_id,
      }
    }
  end

  def default_status
    :not_found
  end

  private

  def header_template
    build_view(Modules::HeaderView).template
  end
end
