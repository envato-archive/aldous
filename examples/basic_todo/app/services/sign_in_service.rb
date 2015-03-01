class SignInService < Aldous::Service
  attr_reader :session, :user

  def initialize(session, user)
    @session = session
    @user = user
  end

  def perform
    session[:user_id] = user.id
    Result::Success.new
  end
end
