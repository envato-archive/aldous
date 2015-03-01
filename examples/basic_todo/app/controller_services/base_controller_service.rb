class BaseControllerService < ::Aldous::ControllerService
  #def default_result_options
    #{
      #current_user: current_user,
    #}
  #end

  #def preconditions
    #[]
  #end
  def default_view_data
    {
      current_user: current_user,
    }
  end
end

