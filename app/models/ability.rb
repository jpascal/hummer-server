class Ability
  include CanCan::Ability
  def initialize(current_user)
    current_user ||= User.new

    # For all
    can [:read,:search,:paste], Suite # Allow read and past2
    can [:read,:paste], Case # Allow read and past2
    can :read, Project
    can :read, Bug

    if current_user.admin
      can :destroy, User do |user|
        current_user != user
      end
      can [:edit,:update, :destroy], Suite
      can :reload, Suite do |suite|
        suite.tempest.present?
      end
      can [:create,:edit,:update,:destroy], Project
      can [:search,:edit,:update], User
    end

    # Only for guests
    if current_user.new_record?
      can :create, Session # Allow signin
      can :create, User # Allow signup
      can :recovery, User
    end

    # For registered users
    unless current_user.new_record?
      can [:edit,:update, :token], User do |user|
        current_user == user
      end
      can [:edit,:update], Project do |project|
        project.owner == current_user
      end
      can :destroy, Session # Allow signout
      can :create, Suite
      can [:edit,:update], Suite do |suite|
        suite.user == current_user
      end
      can :reload, Suite do |suite|
        suite.tempest.present? and suite.user == current_user
      end
      can :destroy, Suite do |suite| # Allow poet tempest reports
        suite.user == current_user
      end
      can :read, User
      can :track, Case # Allow track cases
    end
  end
end
