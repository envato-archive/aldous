class Todos::IndexView::TodoView  < Aldous::Respondable::Renderable
  def template
    {
      partial: 'todos/index_view/todo',
      locals: {
        description: todo.description,
        done: done,
        edit_todo_path: view_context.edit_todo_path(todo),
        delete_todo_path: view_context.todo_path(todo),
        complete_todo_path: view_context.completed_todos_path(todo)
      }
    }
  end

  private

  def todo
    view_data.todo
  end

  def done
    if todo.done
      'Yes'
    else
      'No'
    end
  end
end
