class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new

    # For all
    can [:read,:search,:paste], Suite # Allow read and past2
    can [:read,:paste], Case # Allow read and past2

    # Only for guests
    if user.new_record?
      can :create, Session # Allow signin
      can :create, User # Allow signup
    end

    # For registered users
    unless user.new_record?
      can :destroy, Session # Allow signout
      can [:delete,:create], Suite # Allow poet tempest reports
      can :track, Case # Allow track cases
    end
  end
end
