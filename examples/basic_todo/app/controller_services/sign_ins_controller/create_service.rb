#class SignInsController::CreateService < BaseControllerService
  #def preconditions
    #super + [
      #ParamPresentPrecondition.new(params, :user),
      #SignedInUserNotPresentPrecondition.new(current_user)
    #]
  #end

  #def perform
    #return Result::NotFound.new unless user

    #if user.authenticate(user_params[:password])
      #sign_in
      #Result::Success.new
    #else
      #Result::Failure.new
    #end
  #end

  #private

  #def user
    #@user ||= User.where(email: user_params[:email]).first
  #end

  #def user_params
    #params.fetch(:user, {}).permit(:email, :password)
  #end

  #def sign_in
    #controller.sign_in(user)
  #end
#end
class SignInsController::CreateService < BaseControllerService
  class UserParams < Aldous::Params
    def permitted_params
      params.require(:user).permit(:email, :password)
    end

    def error_message
      'Missing param :user'
    end
  end

  #def perform
    #return TemporaryRedirect.new(Todos::IndexRedirect) if current_user
    #return BadRequest.new(Defaults::BadRequestView, errors: [user_params.error_message]) if user_params.fetch
    #return NotFound.new(SignIns::NewView) unless user

    #if user.authenticate(user_params.fetch[:password])
      #SignInService.new(session, user).perform!
      #Ok.new(Todos::IndexRedirect)
    #else
      #UnprocessableEntity.new(SignIns::NewView, user: user, errors: ["Incorrect credentials"])
    #end
  #end

  #def perform
    #return Result.new(Todos::IndexRedirect) if current_user
    #return Result.new(Defaults::BadRequestView, :bad_request, errors: [user_params.error_message]) if user_params.fetch
    #return Result.new(SignIns::NewView, :not_found) unless user

    #if user.authenticate(user_params.fetch[:password])
      #SignInService.new(session, user).perform!
      #Result.new(Todos::IndexRedirect)
    #else
      #Result.new(SignIns::NewView, user: user, errors: ["Incorrect credentials"])
    #end
  #end

  def perform
    return Todos::IndexRedirect.build if current_user
    return Defaults::BadRequestView.build(:bad_request, errors: [user_params.error_message]) if user_params.fetch
    return SignIns::NewView.build(:not_found) unless user

    if user.authenticate(user_params.fetch[:password])
      SignInService.new(session, user).perform!
      Todos::IndexRedirect.build
    else
      SignIns::NewView.build(:unprocessable_entity, user: user, errors: ["Incorrect credentials"])
    end
  end

  private

  def user_params
    @user_params ||= UserParams.build(params)
  end

  def user
    @user ||= User.where(email: user_params.fetch[:email]).first
  end
end


