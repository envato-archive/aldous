class SignedInUserPresentPrecondition
  include Aldous::ControllerService::Precondition

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def check
    if current_user.present?
      Result::Success.new
    else
      Result::Failure.new
    end
  end
end
