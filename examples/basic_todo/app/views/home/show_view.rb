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
    build_view(Modules::HeaderView).template
  end
end
