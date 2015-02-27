class HomeController::ShowService < BaseControllerService
  def default_result_options
    super.merge({})
  end

  def preconditions
    super + [
      SignedInUserNotPresentPrecondition.new(current_user)
    ]
  end

  def perform
    Result::Success.new
  end
end

