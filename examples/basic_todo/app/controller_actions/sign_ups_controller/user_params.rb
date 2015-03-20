class SignUpsController::UserParams < Aldous::Params
  def permitted_params
    params.require(:user).permit(:email, :password)
  end

  def error_message
    'Missing param :user'
  end
end
