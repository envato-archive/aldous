class Shared::EnsureUserNotDisabledPrecondition < BasePrecondition
  delegate :current_user, :current_ability, to: :action

  def perform
    if current_user && current_user.disabled && !current_ability.can?(:manage, :all)
      return Defaults::ForbiddenView.build(errors: ['Your account has been disabled'])
    end
  end
end
