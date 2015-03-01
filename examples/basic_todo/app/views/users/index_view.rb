class Users::IndexView < Aldous::Respondable::Renderable
  def template
    {
      template: 'users/index',
      locals: {
        header_template: header_template,
        user_templates: user_templates,
      }
    }
  end

  private

  def users
    view_data.users
  end

  def header_template
    build_view(Modules::HeaderView).template
  end

  def user_templates
    users.map do |user|
      user_template(user)
    end
  end

  def user_template(user)
    build_view(Users::IndexView::UserView, user: user).template
  end
end
