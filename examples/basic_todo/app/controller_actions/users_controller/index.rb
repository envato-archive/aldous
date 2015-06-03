class UsersController::Index < BaseAction
  def default_view_data
    super.merge({users: users})
  end

  def perform
    return view_builder.build(Defaults::ForbiddenView) unless current_ability.can?(:index, User)

    view_builder.build(Users::IndexView)
  end

  private

  def users
    User.all
  end
end


