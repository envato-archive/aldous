class Todos::NewView < BaseView
  def template_data
    {
      template: 'todos/new',
      locals: {
        todo: view_data.todo
      }
    }
  end
end
