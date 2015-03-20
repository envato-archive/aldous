class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user || User.new
    @user.roles.each { |role| send(role.name.downcase) }

    if @user.roles.size == 0
      guest
    end
  end

  def guest
  end

  def account_holder
    can :manage, Todo, user_id: user.id
    can :create, User
    can [:read, :update], user
  end

  def admin
    can :manage, :all
  end
end
