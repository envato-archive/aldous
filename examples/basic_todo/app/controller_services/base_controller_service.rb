class BaseControllerService < ::Aldous::ControllerService
  def default_result_options
    {
      current_user: current_user,
    }
  end

  def preconditions
    []
  end
end

