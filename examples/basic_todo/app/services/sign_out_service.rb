class SignOutService < Aldous::Service
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def perform
    session.destroy
    Result::Success.new
  end
end
