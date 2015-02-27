class Home::ShowView < Aldous::Respondable::Renderable
  def template
    {
      template: 'home/show',
      locals: {
        header_template: header_template,
      }
    }
  end

  private

  def header_template
    Modules::HeaderView.new(result, view_context).template
  end
end
