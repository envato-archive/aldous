class BaseAction < ::Aldous::ControllerAction
  def default_view_data
    {
      current_user: current_user,
      current_ability: current_ability,
    }
  end

  def preconditions
    [Shared::EnsureUserNotDisabledPrecondition]
  end

  def default_error_handler(error)
    Defaults::ServerErrorView
  end

  def current_user
    @current_user ||= FindCurrentUserService.perform(session).user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
