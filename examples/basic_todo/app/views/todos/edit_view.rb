class Todos::EditView < BaseView
  def template_data
    {
      template: 'todos/edit',
      locals: {
        todo: view_data.todo
      }
    }
  end
end
