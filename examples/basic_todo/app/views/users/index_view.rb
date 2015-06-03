class Users::IndexView < BaseView
  def template
    {
      template: 'users/index',
      locals: {
        user_views: user_views,
      }
    }
  end

  private

  def users
    view_data.users
  end

  def user_views
    users.map do |user|
      user_view(user)
    end
  end

  def user_view(user)
    view_builder.build(Users::IndexView::UserView, user: user).template
  end
end
