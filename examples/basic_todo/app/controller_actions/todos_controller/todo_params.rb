class TodosController::TodoParams < Aldous::Params
  def permitted_params
    params.require(:todo).permit(:description, :user_id)
  end

  def error_message
    'Missing param :todo'
  end
end
