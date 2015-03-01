#class HomeController::ShowService < BaseControllerService
  #def default_result_options
    #super.merge({})
  #end

  #def preconditions
    #super + [
      #SignedInUserNotPresentPrecondition.new(current_user)
    #]
  #end

  #def perform
    #Result::Success.new
  #end
#end

  #def show
    #Conductor.perform(self, ShowService, {
      #Result::Success                              => Home::ShowView,
      #SignedInUserNotPresentPrecondition::Failure  => Todos::IndexRedirect
    #})
  #end

class HomeController::ShowService < BaseControllerService
  def perform
    return TemporaryRedirect.new(Todos::IndexRedirect) if current_user
    Ok.new(Home::ShowView)
  end
end

