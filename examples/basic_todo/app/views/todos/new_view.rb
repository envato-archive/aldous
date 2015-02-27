class Todos::NewView < Aldous::Respondable::Renderable
  def template
    {
      template: 'todos/new',
      locals: {
        header_template: header_template,
        todo: result.todo
      }
    }
  end

  private

  def header_template
    Modules::HeaderView.new(result, view_context).template
  end
end
