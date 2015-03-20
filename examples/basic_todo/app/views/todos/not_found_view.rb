class Todos::NotFoundView < BaseView
  def template_data
    {
      template: 'todos/not_found',
      locals: {
        user_email: current_user.email,
        todo_id: view_data.todo_id,
      }
    }
  end

  def default_status
    :not_found
  end
end
