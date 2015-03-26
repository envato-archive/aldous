class Shared::NoAldousViewPrecondition < BasePrecondition
  delegate :current_user, :current_ability, to: :action

  def perform
    controller.render(
      template: 'defaults/forbidden',
      status: :unprocessable_entity,
      locals: {error: 'Foobar'}
    )
  end
end
