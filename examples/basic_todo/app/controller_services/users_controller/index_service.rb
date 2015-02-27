class UsersController::IndexService < BaseControllerService
  def default_result_options
    super.merge(
      users: nil,
    )
  end

  def perform
    Success.new(users: User.all)
  end
end

