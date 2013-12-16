class Permissions::User < Permissions::Base
  def initialize(current_user)

    current_user ||= User.new

    # For all
    can "suites", ["index","paste","show"]
    can "cases", ["index","paste","show"]
    can "projects", ["index", "show"]
    can "bugs", ["index", "show"]

    if current_user.admin
      can "users", "destroy" do |user|
        user != current_user
      end
      can "users", ["index", "edit","update"]
    #  can [:edit,:update, :destroy], Suite
      can "suites", "reload" do |suite|
        suite.tempest.present?
      end
      can "projects", ["create","edit","update","destroy"]
    #  can [:search,:edit,:update], User
    end

    # Only for guests
    if current_user.new_record?
      can "sessions", ["create", "new"]
      can "users", "create"
      can "users", "recovery"
    end

    # For registered users
    unless current_user.new_record?
      can "users", ["edit","update","token"] do |user|
        current_user == user
      end
    #  can [:edit,:update], Project do |project|
    #    project.owner == current_user
    #  end
      can "sessions", "destroy" # Allow signout
    #  can :create, Suite
    #  can [:edit,:update], Suite do |suite|
    #    suite.user == current_user
    #  end
      can "suites", "reload" do |suite|
        suite.tempest.present? and suite.user == current_user
      end
    #  can :destroy, Suite do |suite| # Allow poet tempest reports
    #    suite.user == current_user
    #  end
      can "users",["show"]
    #  can :track, Case # Allow track cases
    end

  end
end