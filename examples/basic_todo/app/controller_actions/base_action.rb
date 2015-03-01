class BaseAction < ::Aldous::ControllerAction
  def default_view_data
    {
      current_user: current_user,
    }
  end

  def preconditions
    []
  end

  def default_error_respondable
    Defaults::ServerErrorView
  end

  private

  def current_user
    @current_user ||= FindCurrentUserService.perform(session).user
  end
end

