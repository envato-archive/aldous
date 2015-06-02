class BaseView < ::Aldous::Respondable::Renderable
  def default_template_locals
    {
      current_user: current_user,
      header_view: header_view,
    }
  end

  def current_user
    view_data.current_user
  end

  private

  def header_view
    Modules::HeaderView.build
  end
end
