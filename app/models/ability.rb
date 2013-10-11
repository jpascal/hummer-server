class Ability
  include CanCan::Ability
  def initialize(current_user)
    current_user ||= User.new

    # For all
    can [:read,:search,:paste], Suite # Allow read and past2
    can [:read,:paste], Case # Allow read and past2

    can :read, User

    if current_user.admin
      can :destroy, User do |user|
        current_user != user
      end
      can :edit, User
    end

    # Only for guests
    if current_user.new_record?
      can :create, Session # Allow signin
      can :create, User # Allow signup
    end

    # For registered users
    unless current_user.new_record?
      can :edit, User do |user|
        current_user == user
      end
      can :destroy, Session # Allow signout
      can :create, Suite
      can :destroy, Suite do |suite| # Allow poet tempest reports
        suite.user == current_user
      end
      can :track, Case # Allow track cases
    end
  end
end
