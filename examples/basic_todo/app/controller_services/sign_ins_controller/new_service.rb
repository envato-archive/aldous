#class SignInsController::NewService < BaseControllerService
  #def preconditions
    #super + [
      #SignedInUserNotPresentPrecondition.new(current_user)
    #]
  #end

  #def perform
    #Result::Success.new
  #end
#end

      #Result::Success                             => SignIns::NewView,
      #SignedInUserNotPresentPrecondition::Failure => Todos::IndexRedirect

class SignInsController::NewService < BaseControllerService
  def perform
    return TemporaryRedirect.new(Todos::IndexRedirect) if current_user

    Ok.new(SignIns::NewView)
  end
end

