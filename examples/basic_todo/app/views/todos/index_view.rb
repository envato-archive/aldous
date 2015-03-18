class Todos::IndexView < BaseView
  def template_data
    {
      template: 'todos/index',
      locals: {
        todo_views: todo_views,
      }
    }
  end

  private

  def todos
    view_data.todos
  end

  def todo_views
    todos.map do |todo|
      todo_view(todo)
    end
  end

  def todo_view(todo)
    build_view(Todos::IndexView::TodoView, todo: todo)
  end
end
