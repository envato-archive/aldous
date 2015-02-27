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
    result.todos
  end

  def header_template
    Modules::HeaderView.new(result, view_context).template
  end

  def todo_templates
    todos.map do |todo|
      todo_template(todo)
    end
  end

  def todo_template(todo)
    Todos::IndexView::TodoView.new(build_result(todo: todo), view_context).template
  end
end
