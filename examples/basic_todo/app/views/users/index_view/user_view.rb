class Users::IndexView::UserView < Aldous::Respondable::Renderable
  def template
    {
      partial: 'users/index_view/user',
      locals: {
        email: user_email,
      }
    }
  end

  private

  def user
    view_data.user
  end

  def user_email
    if user
      user.email
    end
  end
end
