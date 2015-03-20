class UsersController::Index < BaseAction
  def default_view_data
    super.merge({users: users})
  end

  def perform
    return build_view(Defaults::ForbiddenView) unless current_ability.can?(:index, User)

    build_view(Users::IndexView)
  end

  private

  def users
    User.all
  end
end


