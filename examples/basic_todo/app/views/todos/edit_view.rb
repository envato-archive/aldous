class Todos::EditView < Aldous::Respondable::Renderable
  def template
    {
      template: 'todos/edit',
      locals: {
        header_template: header_template,
        todo: view_data.todo
      }
    }
  end

  private

  def header_template
    build_view(Modules::HeaderView).template
  end
end
