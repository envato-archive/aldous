class SignUpsController::NewService < BaseControllerService
  def perform
    Result::Success.new
  end
end

