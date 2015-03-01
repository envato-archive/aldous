class UsersController::Index < BaseAction
  def default_view_data
    super.merge({users: users})
  end

  def perform
    return Defaults::ForbiddenView.build unless current_ability.can?(:index, User)

    Users::IndexView.build
  end

  private

  def users
    User.all
  end
end


