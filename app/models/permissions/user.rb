class Permissions::User < Permissions::Base
  def initialize(current_user)

    # for all users
    can "suites", ["index","paste","show","search"]
    can "projects", ["index", "show"]
    can "bugs", ["index", "show"]
    can "compares", ["index","show"]
    can "cases", ["index","paste","show"]
    can "cases", ["index","paste","show"]
    can "tracker", "show" do |test|
      test.bug.present?
    end

    if current_user.new_record?
      # anonymous
      can "sessions", ["create", "new"]
      can "users", ["create", "recovery"]

    else
      # existent user
      can "sessions", "destroy"
      can "projects", ["edit","update"] do |project|
        project.owner == current_user
      end
      can "suites", ["create","new"]
      can "suites", ["edit","update"] do |suite|
        suite.user == current_user
      end
      can "suites", "reload" do |suite|
        suite.tempest.present? and suite.user == current_user
      end
      can "users",["show"]
      can "tracker", ["show","update"]
      can "users", ["edit","update","token"] do |user|
        current_user == user
      end
      # API permissions
      can "api/projects", [ "index", "show" ]
      can "api/suites", [ "index", "create", "show" ]
      if current_user.admin?
        can "users", ["index", "edit","update", "serarch"]
        can "users", "destroy" do |user|
          user != current_user
        end
        can "suites", ["edit","update", "destroy"]
        can "suites", "reload" do |suite|
          suite.tempest.present?
        end
        can "projects", ["create","new","edit","update","destroy"]
      end
    end
  end
end