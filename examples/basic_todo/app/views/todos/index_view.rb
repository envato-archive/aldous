class Todos::IndexView < Aldous::Respondable::Renderable
  def template
    {
      template: 'todos/index',
      locals: {
        header_template: header_template,
        todo_templates: todo_templates,
      }
    }
  end

  private

  def todos
    view_data.todos
  end

  def header_template
    build_view(Modules::HeaderView).template
  end

  def todo_templates
    todos.map do |todo|
      todo_template(todo)
    end
  end

  def todo_template(todo)
    build_view(Todos::IndexView::TodoView, todo: todo).template
  end
end
