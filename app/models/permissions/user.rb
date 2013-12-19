class Permissions::User < Permissions::Base
  def initialize(current_user)

    current_user ||= User.new({})

    # For all
    can "suites", ["index","paste","show","search"]
    can "cases", ["index","paste","show"]
    can "projects", ["index", "show"]
    can "bugs", ["index", "show"]
    can "compares", ["index","show"]
    can "tracker", "show" do |test|
      test.bug.present?
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
      can "projects", ["edit","update"] do |project|
        project.owner == current_user
      end
      can "sessions", "destroy" # Allow signout
      can "suites", ["create","new"]
      can "suites", ["edit","update"] do |suite|
        suite.user == current_user
      end
      can "suites", "reload" do |suite|
        suite.tempest.present? and suite.user == current_user
      end
      can "suites", "destroy" do |suite|
        suite.user == current_user
      end
      can "users",["show"]
      can "tracker", ["show","update"]
    end

    if current_user.admin
      can "users", "destroy" do |user|
        user != current_user
      end
      can "users", ["index", "edit","update", "serarch"]
      can "suites", ["edit","update", "destroy"]
      can "suites", "reload" do |suite|
        suite.tempest.present?
      end
      can "projects", ["create","new","edit","update","destroy"]
    end

    # API permissions (all time have user)
    if current_user
      can "api/projects", [ "index", "show" ]
      can "api/suites", [ "index", "create", "show" ]
    end
  end
end