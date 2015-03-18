class CreateUserService < Aldous::Service
  attr_reader :user_data_hash

  def initialize(user_data_hash)
    @user_data_hash = user_data_hash
  end

  def raisable_error
    Aldous::Errors::UserError
  end

  def default_result_data
    {user: nil}
  end

  def perform
    user = User.new(user_data_hash)
    user.roles << Role.where(name: "account_holder").first

    if user.save
      Result::Success.new(user: user)
    else
      Result::Failure.new
    end
  end
end
