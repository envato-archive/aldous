class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(get_user_id_from_session) if get_user_id_from_session
  end

  def sign_in(user)
    set_user_id_in_session(user.id)
  end

  def sign_out
    session.destroy
  end

  def view_assigns
    {}
  end

  private

  def get_user_id_from_session
    user_id_string = session[:user_id]
    user_id_string.to_i if user_id_string
  end

  def set_user_id_in_session(user_id)
    session[:user_id] = user_id
  end
end
